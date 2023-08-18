#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
certs.py
~~~~~~~~

This module returns the preferred default CA certificate bundle.

If you are packaging Requests, e.g., for a Linux distribution or a managed
environment, you can change the definition of where() to return a separately
packaged CA bundle.
"""

import os
import sys
import atexit
import imp

cert_paths = """
/etc/pki/tls/certs/ca-bundle.crt
/etc/ssl/certs/ca-certificates.crt
/usr/share/ssl/certs/ca-bundle.crt
/usr/local/share/certs/ca-root.crt
/etc/ssl/cert.pem
/System/Library/OpenSSL/certs/cert.pem
/usr/local/share/certs/ca-root-nss.crt
/etc/ssl/ca-bundle.pem
""".strip().split()


def find_system_ca_bundle():
    if os.name == 'nt':
        try:
            import wincertstore
        except ImportError:
            return None

        win_certfile = wincertstore.CertFile()
        for store_name in ('MY', 'CA', 'ROOT'):
            win_certfile.addstore(store_name)
        atexit.register(win_certfile.close)

        return win_certfile.name
    else:
        for cert_path in cert_paths:
            if os.path.isfile(cert_path):
                return cert_path
        return None


def where():
    """Return the preferred certificate bundle."""

    if os.name == 'nt':
        override_path = os.path.expandvars(r'${SystemDrive}\cfn\ca-override.pem')
    else:
        override_path = '/etc/cfn/ca-override.pem'

    override_path = os.getenv('CA_OVERRIDE', override_path)

    if os.path.isfile(override_path):
        return override_path

    system_ca_bundle_path = find_system_ca_bundle()
    if system_ca_bundle_path and os.path.isfile(system_ca_bundle_path):
        return system_ca_bundle_path

    # Modification for compilation by py2exe:
    if (hasattr(sys, "frozen") or  # new py2exe
            hasattr(sys, "importers")  # old py2exe
            or imp.is_frozen("__main__")):  # tools/freeze
        return os.path.join(os.path.dirname(sys.executable), 'cacert.pem')
    # end py2exe

    # vendored bundle inside Requests
    return os.path.join(os.path.dirname(__file__), 'cacert.pem')

if __name__ == '__main__':
    print(where())
