import sys
import base64
import reedsolo  # Install with `pip install reedsolo`

data = sys.stdin.buffer.read()
# Encode using Reed-Solomon with 50 extra bytes for error correction
encoded = base64.b16encode(reedsolo.RSCodec(50).encode(data))
# split into 64-char long lines, with each line split into 8-char long words
lines = [encoded[i:i + 64] for i in range(0, len(encoded), 64)]
words = [[line[i:i + 8] for i in range(0, len(line), 8)] for line in lines]
formatted = b"\n".join([b" ".join(line) for line in words])
# write to stdout
sys.stdout.buffer.write(formatted + b"\n")
