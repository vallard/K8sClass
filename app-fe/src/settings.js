const api_endpoint = process.env.NODE_ENV === 'production' ? "https://api.k8s.castlerock.ai" : "http://localhost:80"
export default api_endpoint;
