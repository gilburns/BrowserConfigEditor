# Configuration Examples

This folder contains preset browser policy configurations that can be imported into BrowserConfigEditor. These examples provide starting points for common security and enterprise deployment scenarios.

## Available Examples

### Microsoft Edge (plist or json)

| File | Description |
|------|-------------|
| `Edge-CIS-Level1`  | CIS Benchmark Level 1 policies for Microsoft Edge. These settings provide essential security hardening while maintaining broad compatibility and usability. Suitable for most enterprise environments. |
| `Edge-CIS-Level2` | CIS Benchmark Level 2 policies for Microsoft Edge. These settings provide more restrictive security controls for environments requiring higher security. May impact some functionality in exchange for increased protection. |

## Usage

1. Open BrowserConfigEditor
2. Select Microsoft Edge (or appropriate browser) using **File > Select Browser...**
3. Import the desired configuration using **File > Import Configuration...**
4. Review and adjust policies as needed for your environment
5. Export the final configuration using **File > Export Configuration...**

## About CIS Benchmarks

The [Center for Internet Security (CIS)](https://www.cisecurity.org/) provides consensus-based security configuration benchmarks. These presets are based on CIS recommendations and should be reviewed against the latest published benchmarks for your specific version.

- **Level 1**: Recommended baseline settings that can be implemented with minimal impact on functionality
- **Level 2**: Extended security settings for high-security environments that may limit certain features (Apply both Level 1 and 2 to achieve the full baseline)

## Contributing

Additional example configurations are welcome. When contributing:

- Use descriptive filenames indicating the browser and purpose
- Include both `.json` and `.plist` formats when possible
- Document the source or rationale for the configuration
- Test the configuration imports correctly in BrowserConfigEditor

## Disclaimer

These configurations are provided as starting points and examples. Always review and test policies in your environment before deployment. Security requirements vary by organization, and these presets may need adjustment to meet your specific compliance and operational needs.
