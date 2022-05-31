# Online_food_ordering_system

Our queries:
# Simple
- [X] Give the list of all the items available in a restaurant whose Restaurant ID(Rid) is given. ***(customer's home page to menu uses this query )*** 
- [X] List out the number of orders each customer has placed using the application.***(implemented in orders.html where number of orders od the customer is given)***
- [X] Give a list of all the coupons that have expired. ***(checked while listing out the coupons)***
- [X] Display number of restaurants having the same rating. ***(showed that we have so many restaurants with rating 4 or more(in cust_home page))***
- [X] Display which delivery person has been assigned to which order. ***(listed in orders.html where it says "your order is delivered by so and so")***
# Complex
- [X] For every delivery person, add a remark based on their ratings. If the rating is above 4 and below or equal to 5, give “EXPERT”,
If the rating is above 3 and below or equal to 4, give “PROFICIENT”, If the rating is above 2 and below or equal to 3, give “COMPETENT”, If the rating is above 1 and below or equal to 2, give “SATISFACTORY”, If the rating is above 0 and below or equal to 1, give “NOVICE” as the remarks. ***(used this in /after_review and updated the value of remarks)***
- [X] Give the details of the restaurant and customer of an order to the assigned delivery person. ***(order details of a delivery_person's page)***
- [ ] All the customers who have never placed any order. ***(will be done by the admin to remove the users or something )***
- [X] Give the total amount of all the orders that have been placed. ***(used this for cart and order total )***
- [ ] From all the orders, select the orders where the total price is more than average price spent by customers for any order. ***(can probably call them supercustomer and create a new coupon for them??)***
- [X] Trigger for updating the cart's total_price ***(used this for cart total )***


### Repository Structure 


```bash
.
├── static
│   └── Loginstyles.css
├── templates
│   ├── cart.html
│   ├── confirm_order.html
│   ├── cust_home.html
│   ├── delivery_home.html
│   ├── delivery_profile.html
│   ├── edit.html
│   ├── edit_profile.html
│   ├── employee_order.html
│   ├── employee_rest.html
│   ├── error.html
│   ├── login.html
│   ├── menu.html
│   ├── newCustomer.html
│   ├── newDelivery.html
│   ├── newMenu.html
│   ├── newRestaurant.html
|   ├── orders.html
|   └── review.html
├── final_create.sql 
├── insert_final.sql
├── queries.sql
├── sample.py
└── README.md

```

