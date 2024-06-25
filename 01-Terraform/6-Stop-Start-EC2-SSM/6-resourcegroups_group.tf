resource "aws_resourcegroups_group" "resourcegroups-App1" {
  name = "resourcegroups-App1"
  description = "Group of EC2 instances App1"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "App1",
      "Values": ["True"]
    }
  ]
}
JSON
  }
}