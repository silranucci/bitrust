use anyhow::Result;
use bitrust_proto::{BitrustClient, PutRequest};
use tonic::transport::Channel;

pub async fn handle(client: &mut BitrustClient<Channel>, key: String, value: String) -> Result<()> {
    let request = PutRequest {
        key: key.clone(),
        value: value.clone(),
    };

    client.put(request).await?;

    println!("{key}-{value}");

    Ok(())
}

