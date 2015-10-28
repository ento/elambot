#!/bin/bash

src="src/*.elm src/**/*.elm"
make_target=build/elm-module.js
parts=("src/elm-module-preamble.js" "$make_target" "src/elm-module-postamble.js")
output=build/elm.js
artifact=build/elambot.zip

mkdir -p build

elm-make $src --output=$make_target || exit 1

echo '' > "$output"
for part in "${parts[@]}"; do
    cat "$part" >> "$output" || exit 1
done

rm -f $artifact

zip $artifact -j $output
zip $artifact -j src/index.js
if [ -d node_modules ];
then
    zip $artifact -r node_modules
fi

s3_bucket=inhouse-packages
s3_key=elambot.zip
lambda_func_name=PostToChatBotMailbox
lambda_region=us-west-2

aws s3 cp $@ $artifact s3://$s3_bucket/$s3_key || exit 1

aws lambda update-function-code \
    $@ \
    --region $lambda_region \
    --function-name $lambda_func_name \
    --s3-bucket $s3_bucket \
    --s3-key $s3_key \
    --publish
