use std::path::PathBuf;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let proto_dir = PathBuf::from("./proto");
    let proto_file = proto_dir.join("v1/bitrust.proto");

    // TODO: conditional build
    tonic_prost_build::configure()
        .build_server(true)
        .build_client(true)
        .compile_protos(&[&proto_file], &[&proto_dir])?;

    println!("cargo:rerun-if-changed={}", proto_file.display());
    Ok(())
}
