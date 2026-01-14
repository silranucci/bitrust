use anyhow::Result;
use bitrust_proto::BitrustClient;
use clap::{Parser, Subcommand};

mod get;
mod put;

// TODO: use env or cli option
const DEFAULT_ENDPOINT: &str = "http://[::1]:50051";

#[derive(Parser)]
#[command(name = "bitrust")]
#[command(about = "Bitrust key-value store CLI")]
#[command(version)]
pub struct Cli {
    #[arg(short, long, default_value = DEFAULT_ENDPOINT, global = true)]
    pub endpoint: String,

    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Store a key-value pair
    Put { key: String, value: String },

    /// Retrieve a value by key
    Get { key: String },
}

impl Cli {
    pub async fn run(self) -> Result<()> {
        let mut client = BitrustClient::connect(self.endpoint).await?;

        match self.command {
            Commands::Put { key, value } => put::handle(&mut client, key, value).await?,

            Commands::Get { key } => get::handle(&mut client, key).await?,
        }

        Ok(())
    }
}
