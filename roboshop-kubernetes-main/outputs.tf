output "REDIS_ENDPOINT" {
  value = module.ELASTICACHE.REDIS_ENDPOINT
}

output "DOCDB_ENDPOINT" {
  value = module.DOCDB.DOCDB_ENDPOINT
}

output "MYSQL_ENDPOINT" {
  value = module.RDS.MYSQL_ENDPOINT
}

