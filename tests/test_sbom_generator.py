from openssl_base.sbom_generator import generate_openssl_sbom

def test_basic_sbom():
    sbom = generate_openssl_sbom("test-package", "1.0.0")
    assert sbom["metadata"]["component"]["name"] == "test-package"
    assert sbom["bomFormat"] == "CycloneDX"

def test_fips_sbom():
    sbom = generate_openssl_sbom("openssl", "3.4.1", is_fips=True, fips_cert="4985")
    props = sbom["metadata"]["component"]["properties"]
    assert any(p["name"] == "openssl:fips_certificate" and p["value"] == "4985" for p in props)
