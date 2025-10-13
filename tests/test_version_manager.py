from openssl_base.version_manager import get_openssl_version, parse_openssl_version

def test_semantic_version():
    assert get_openssl_version("3.4.1", is_fips=False) == "3.4.1"

def test_fips_version():
    v = get_openssl_version("3.4.1", is_fips=True, git_hash="abc12345")
    assert v.startswith("3.4.1+fips.") and v.endswith(".abc12345")

def test_parse_version():
    r = parse_openssl_version("3.4.1+fips.20251013120000.abc12345")
    assert r["semantic"] == "3.4.1"
    assert r["metadata"]["build_type"] == "fips"
    assert r["metadata"]["git_hash"] == "abc12345"
