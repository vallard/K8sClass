import api_endpoint from '../../settings'

const headers = {
    'Content-Type': 'application/json',
};

const api = {
    get(data) {
        var url = api_endpoint + data.path
        //console.log("url: ", url);
        const response = fetch(url, {
            method: 'GET',
            headers: data.headers ? data.headers : headers,
        })
            .then(response => response.json())
        return response;
    },
    send(data) {
        //console.log("sending: ", data.data);
        //console.log("headers: ", data.headers);
        //console.log("formData: ", data.formData);
        var url = api_endpoint + data.path;
        const response = fetch(url, {
            method: 'POST',
            headers: data.headers ? data.headers : headers,
            body: data.data ? JSON.stringify(data.data) : data.formData,
        }).then(response => response.json());
        return response;
    },
    delete(data) {
        console.log("deleting: ", data.data)
        var url = api_endpoint + data.path;
        const response = fetch(url, {
            method: 'DELETE',
            headers: data.headers ? data.headers : headers,
            body: data.data ? JSON.stringify(data.data) : null,
        }).then(response => response.json());
        return response;
    }
}

export default api;
