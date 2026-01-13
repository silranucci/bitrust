use clap::{Parser, Subcommand, command};

mod get;
mod set;

#[derive(Parser)]
#[command(name = "bitrust-cli")]
#[command(about = "bitrust command line interface")]
#[command(version)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Add a new key-value pair
    Set {
        /// Key
        key: String,

        /// Value
        value: String,
    },

    /// Retrieve a value associated with a specific key
    Get {
        /// Key
        key: String,
    },
}

impl Cli {
    pub fn run(self) -> () {
        match self.command {
            Commands::Set { key, value } => match set::handle(key, value) {
                Ok((key, value)) => println!("{}-{}", key, value),
                Err(e) => eprintln!("{e}"),
            },

            Commands::Get { key } => match get::handle(key) {
                Ok(value) => println!("{value}"),
                Err(e) => eprintln!("{e}"),
            },
        }
    }
}
