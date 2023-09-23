describe('The Resume Page', () => {
  
    it("gets visitors count", () => {
        cy.request("GET", "https://y6v9mkpq3b.execute-api.us-east-1.amazonaws.com/default/updateDynamoDB").then((response) => {
        expect(response.body.Attributes).to.have.property("count")
        expect(response.body.Attributes).to.have.property("count id")
        expect(response.body.ResponseMetadata.HTTPStatusCode).to.eq(200)
        })
    })
      
    
  })