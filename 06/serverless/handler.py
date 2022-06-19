try:
  import unzip_requirements
except ImportError:
  pass
import json, os, sys, re
import base64
import boto3
from botocore.signers import RequestSigner
from kubernetes import client
from kubernetes.client import ApiClient, Configuration
from kubernetes.config.kube_config import KubeConfigLoader


def get_bearer_token(cluster_id):
    """
    Get the AWS token for the user.  This is from this lovely code base: 
    https://github.com/kubernetes-sigs/aws-iam-authenticator#api-authorization-from-outside-a-cluster
    """
    STS_TOKEN_EXPIRES_IN = 60
    session = boto3.session.Session()

    client = session.client('sts')
    service_id = client.meta.service_model.service_id
    signer = RequestSigner(
        service_id,
        region,
        'sts',
        'v4',
        session.get_credentials(),
        session.events
    )
    params = {
        'method': 'GET',
        'url': 'https://sts.{}.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15'.format(region),
        'body': {},
        'headers': {
            'x-k8s-aws-id': cluster_id
        },
        'context': {}
    }
    signed_url = signer.generate_presigned_url(
        params,
        region_name=region,
        expires_in=STS_TOKEN_EXPIRES_IN,
        operation_name=''
    )
    base64_url = base64.urlsafe_b64encode(signed_url.encode('utf-8')).decode('utf-8')
    # remove any base64 encoding padding:
    return 'k8s-aws-v1.' + re.sub(r'=*', '', base64_url)


# normal headers we return when things are good. 
headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": True
}

cluster = os.getenv('CLUSTER', 'matomo')
region = os.getenv('REGION', 'us-west-2')

def formatted_error(message, statusCode=400):
    print("error:" , message)
    return {
        "statusCode": statusCode,
        "headers": headers,
        "body": json.dumps({"error": message})
    }

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return int(obj)
        return super(DecimalEncoder, self).default(obj)


def serializer(obj):
    """Default JSON serializer."""
    import calendar, datetime

    if isinstance(obj, datetime.datetime):
        if obj.utcoffset() is not None:
            obj = obj - obj.utcoffset()
        millis = int(
            calendar.timegm(obj.timetuple()) * 1000 +
            obj.microsecond / 1000
        )
        return millis
    raise TypeError('Not sure how to serialize %s' % (obj,))


def make_config():
    """
    List kubernetes deployments in the cluster. 
    """
    eks_client = boto3.client('eks')
    cluster_details = eks_client.describe_cluster(name=cluster)
    #print(json.dumps(cluster_details, indent=4, sort_keys=True, default=serializer))
    conn = {
            "name": cluster_details['cluster']['name'],
            "endpoint": cluster_details['cluster']['endpoint'],
            "ca": cluster_details['cluster']['certificateAuthority']['data'],
    }

    token = get_bearer_token(conn['name'])
    #print("Token: ", token)
    #print("ca is: ", conn['ca'])
    kube_config = {
         "contexts": [
            {
                "name": conn['name'],
                "context" : {
                    "cluster": conn['name'],
                    "user": "aws_user",
                }
            }
        ],
        "clusters" : [
            {
                "name" : conn['name'],
                "cluster": {
                    "server": conn['endpoint'],
                    "certificate-authority-data": conn['ca']
                    }
                }
            
        ],
        "users" : [
            {
                "name": "aws_user",
                "user": {
                    "token": token    
                }

            } 
        ]
    }
    return conn['name'], kube_config


def list_deployments(event, context):
    context, kube_config = make_config() 
    loader = KubeConfigLoader(config_dict=kube_config, active_context=context)
    config = Configuration()
    loader.load_and_set(config)
    apiClient = ApiClient(configuration=config)
    v1 = client.CoreV1Api(apiClient)
    pods = []
    try: 
        ret = v1.list_pod_for_all_namespaces(watch=False)
        for i in ret.items:
            pods.append({"ip": i.status.pod_ip, "namespace": i.metadata.namespace, "name": i.metadata.name})

    except client.rest.ApiException as e: 
        formatted_error(str(e))

    return {
        "statusCode": 200,
        "headers": headers,
        "body": json.dumps({"pods": pods}, cls=DecimalEncoder, default=serializer)
    }


def create_deployments(event, context):
    """
    Create a Kubernetes deployment. 
    """
    return formatted_error("Not yet implemented.")

if __name__ == "__main__":
    list_deployments(None, None)
