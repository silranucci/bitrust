use anyhow::{Result, bail};
use bitrust_proto::{BitrustClient, GetRequest, get_response::Result as GetResult};
use tonic::transport::Channel;

pub async fn handle(client: &mut BitrustClient<Channel>, key: String) -> Result<()> {
    let request = GetRequest { key };
    let response = client.get(request).await?.into_inner();

    match response.result {
        Some(GetResult::Value(v)) => {
            println!("{}", v);
            Ok(())
        }
        Some(GetResult::NotFound(_)) => {
            eprintln!("Not found");
            bail!("NotFound")
        }
        None => {
            eprintln!("Empty response");
            bail!("EmptyResponse")
        }
    }
}
