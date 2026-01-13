use anyhow::Result;

pub fn handle(key: String, value: String) -> Result<(String, String)> {
    Ok((key, value))
}
