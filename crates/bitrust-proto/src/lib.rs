pub mod bitrust {
    pub mod v1 {
        tonic::include_proto!("bitrust.v1");
    }
}

// Types
pub use bitrust::v1::{GetRequest, GetResponse, PutRequest, PutResponse, get_response};

pub use bitrust::v1::bitrust_server::{Bitrust, BitrustServer};

pub use bitrust::v1::bitrust_client::BitrustClient;
