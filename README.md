## Installation

* Create an API in AWS API Gateway
* Create IAM Policy and Role
* Created Lambda function with the role
* Assigned function as the POST method handler for the API
* Add mapping template to the method for Content-Type `application/x-www-form-urlencoded`
```
{
   "body": "$input.path('$')"
}
```
* Added outgoing webhook to Slack and specify the API endpoint
* Publish
```
# Expects s3://inhouse-packages/ bucket to be writable
./script/publish.sh --additional-args are passed-to aws command
```
