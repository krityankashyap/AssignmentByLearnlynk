Stripe Payment Implementation

1. Create checkout session with stripe API when user clicks pay button
   - pass amount, success url, cancel url
   - get session id back

2. Save payment info in database
   - store session id, application id, amount
   - set status to "pending"

3. Redirect user to stripe payment page

4. Setup webhook endpoint to receive payment confirmation from stripe
   - verify webhook signature for security
   - listen for checkout.session.completed event

5. When payment succeeds, update our database
   - find record by session id
   - change status to "completed"

6. Update application status to show payment received

7. Add entry to timeline table for tracking

8. Handle failures - if payment fails update status and notify user via email