# En este fichero definimos el filtro para buscar las instancias y crear el grupo de instancias con las que vamos a trabajar
# en este caso vamos a buscar las instancias con el tag App1=True
resource "aws_resourcegroups_group" "resourcegroups_App1" {
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