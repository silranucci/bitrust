use bitrust_proto::{
    Bitrust, BitrustServer, GetRequest, GetResponse, PutRequest, PutResponse,
    get_response::Result as GetResult,
};
use tonic::transport::Server;

#[derive(Debug, Default)]
struct BitrustService {}

#[tonic::async_trait]
impl Bitrust for BitrustService {
    async fn get(
        &self,
        request: tonic::Request<GetRequest>,
    ) -> Result<tonic::Response<GetResponse>, tonic::Status> {
        let key = &request.get_ref().key;
        println!("Arrived: {key}");

        let response = GetResponse {
            result: Some(GetResult::Value(key.clone())),
        };

        Ok(tonic::Response::new(response))
    }

    async fn put(
        &self,
        request: tonic::Request<PutRequest>,
    ) -> Result<tonic::Response<PutResponse>, tonic::Status> {
        let key = &request.get_ref().key;
        let value = &request.get_ref().value;
        println!("Arrived: {key}-{value}");

        let response = PutResponse {
            key: key.clone(),
            value: value.clone(),
        };

        Ok(tonic::Response::new(response))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;
    let bitrust = BitrustService::default();

    Server::builder()
        .add_service(BitrustServer::new(bitrust))
        .serve(addr)
        .await?;

    Ok(())
}
