import sys
import base64
import reedsolo  # Install with `pip install reedsolo`

# Read the data removing all whitespace
data = "".join(sys.stdin.read().split())
# Decode using Reed-Solomon with 50 extra bytes for error correction
decoded, _, _ = reedsolo.RSCodec(50).decode(base64.b16decode(data))
sys.stdout.buffer.write(decoded)
