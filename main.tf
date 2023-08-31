module "appsync" {
  source  = "terraform-aws-modules/appsync/aws"
  version = "2.2.0"

  name = random_pet.this.id

  schema = file("schema.graphql")

  visibility = "GLOBAL"

  api_keys = {
    future  = "2023-09-03T15:00:00Z"
    default = null

  }
  
  authentication_type = "API_KEY"

  logging_enabled = true

  log_field_log_level = "ALL"

  logs_role_name = "role_${random_pet.this.id}"


  functions = {
    formatPostItem = {
      kind        = "PIPELINE"
      type        = "Mutation"
      data_source = "None"
      runtime = {
        name = "APPSYNC_JS"
      }

      code = file("src/formatPostItem.js")
    }
    createPostItem = {
      kind        = "PIPELINE"
      type        = "Mutation"
      data_source = "dynamodb"
      runtime = {
        name = "APPSYNC_JS"
      }

      code = file("src/createPostItem.js")
    }
    getPostFromTable = {
      kind        = "PIPELINE"
      type        = "Query"
      data_source = "dynamodb"
      runtime = {
        name = "APPSYNC_JS"
      }

      code = file("src/getPostFromTable.js")
    }
  }

  datasources = {
    None = {
      type = "NONE"
    }

    dynamodb = {

      type = "AMAZON_DYNAMODB"

      # Note: dynamic references (module.dynamodb_table1.dynamodb_table_id) do not work unless you create this resource in advance
      table_name = "my-posts"
      region     = "us-east-2"

    }

  }
  resolvers = {



    "Mutation.addPost" = {
      kind  = "PIPELINE"
      type  = "Mutation"
      field = "addPost"
      runtime = {
        name = "APPSYNC_JS"
      }
      code = file("src/createPostResponse.js")
      functions = [
        "formatPostItem",
        "createPostItem"
      ]
    }
    "Query.getPost" = {
      kind  = "PIPELINE"
      type  = "Query"
      field = "getPost"
      runtime = {
        name = "APPSYNC_JS"
      }
      code = file("src/getPostFromTable.js")
      functions = [
        "getPostFromTable"
      ]
    }

  }


}

module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "my-posts"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

resource "random_pet" "this" {
  length = 2

}