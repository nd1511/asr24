#!/usr/bin/env bash

# Convert an 8 kHz .wav file into a string of Aspire phones.

if [ $# != 2 ]; then
  echo "Usage: $0 [cz|hu|ru] in.wav > phones.txt"
  exit 1
fi
if [ $1 == cz ]; then
  config=CZ
elif [ $1 == hu ]; then
  config=HU
elif [ $1 == ru ]; then
  config=RU
else
  echo "Usage: $0 [cz|hu|ru] in.wav > phones.txt"
  exit 1
fi
# Don't use phnrec's EN config, because that's 16 kHz instead of 8,
# and because it's likely not as good as ASPIRE's English model.

dir=../brno-phnrec/PhnRec
config=${dir}/PHN_${config}_SPDAT_LCRC_N1500

# Run phnrec.  Discard its timing info; keep only the phones.
# Discard useless phones.
# Convert phones from SAMPA to IPA (*before* joining into one line,
# because node.js javascript's readline notices input only after a newline!).
# Join phones into one line.
${dir}/phnrec -c $config -i $2 -o /dev/stdout |
  cut -f3 -d' ' | grep -Ev 'int|pau|spk' | ./sampa2ipa.js | tr '\n' ' ' | ./ipa2aspire.rb

# Append a newline.
echo
