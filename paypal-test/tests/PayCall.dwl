import * from bat::BDD
import * from bat::Assertions

var context = bat::Mutable::HashMap()
var api_endpoint = config.url

---
suite("Pay Pal Test suite") in [
  it must ('login') in [
    POST`$(api_endpoint)/oauth2/token` with {
      headers: {
        "Authorization": "Basic QVYzcF91eVhUT21PTnpxQl9iQjFraVAwdWxKRG1hcXQ0SF8taEZZTHZmaVZWZjY3YzlPSHhXTThaTzNUOGp6R3JhM1drcTRrLTBTRmw0SEo6RU42MGQwWHc1c2NMSzBtMjJDcmJyNHNzdnRKZzZaa3BiLVBkb3RuOE4xcTgwc3ZXbl9SUE12UzZHNmktSU9uN1NkTHF2UGJIcnZwUFpiM3g=",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        "grant_type": "client_credentials"
      }
    } assert [
      $.response.status mustEqual 200
    ] execute [
     context.set('access_token', $.response.body.access_token)
    ]
  ],
  it must('list invoices') in [
    GET`$(api_endpoint)/invoicing/invoices?page=3&page_size=4&total_count_required=true` with {
      headers: {
        "Authorization": "Bearer $(context.get('access_token'))",
        "Content-Type": "application/json"
      }
    } assert [
      $.response.status mustEqual 200
    ] execute [
     context.set('totalInvoices', $.response.body.total_count)
    ]
  ]
]