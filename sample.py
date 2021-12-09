import psycopg2
from flask import Flask, request, redirect, url_for, render_template, session, send_from_directory, send_file, flash, abort, make_response
import decimal
import itertools 
app = Flask(__name__)
try:
    db = psycopg2.connect(database="h8", user = "postgres", password="Shruvid2")
except:
    print("not connected")
    exit()
cur = db.cursor()

@app.route('/cust_home', methods=['GET', 'POST'])
def customer_home():
    try:
        cid = session['id']
        cur.execute("SELECT Fname FROM CUSTOMER where Cid=%s", (cid,))
        cust_name = cur.fetchall()
        cust_name = list(itertools.chain(*cust_name))[0]
        if request.method == 'POST':
            search = request.form['search'].lower().title()
            print(search)
            cur.execute("SELECT Rname, Rating, Rid, Cuisine, Raddress FROM restaurant where Rname=%s", (search,))
            row = cur.fetchall()
            row1 = [[''.join(i[0]), float(i[1]), i[2], ''.join(i[3]), (i[4].split(","))[-3] ]  for i in row]
            print(row1)
        else:
            cur.execute("SELECT Rname, Rating, Rid, Cuisine, Raddress FROM restaurant")
            row = cur.fetchall() 
            #print(row) Decimal.decimal("")
            row1 = [[''.join(i[0]), float(i[1]), i[2], ''.join(i[3]), (i[4].split(","))[-3] ]  for i in row]
            #print(row)
            
            #print(cid)
        cur.execute("SELECT Count(*), Rating FROM RESTAURANT GROUP BY Rating;")
        rate_grp = cur.fetchall() 
        rate_grp = [[int(i[0]), float(i[1])]  for i in rate_grp]
        print(rate_grp)
        above_4 = 0
        for i in range(len(rate_grp)):
            if rate_grp[i][1] >= 4:
                above_4 += rate_grp[i][0]
        print(above_4)
        return render_template('cust_home.html', length=len(row1), row=row1, cid=cid,\
            name=cust_name, above_4=above_4)
    except Exception as e:
        return render_template("error.html", error=e)

@app.route('/cart', methods = ['POST', 'GET'])
def cart():
    try:
        cid = session['id']
        rname = "None"
        cart_rest = 0
        cur.execute("SELECT * from CITEMS where Ccart_id=%s", (cid,)) 
        prev_items = cur.fetchall()
        if len(prev_items) != 0:
            prev_items = [[''.join(i[0]), i[1], i[3]]  for i in prev_items][0]
            cur.execute("SELECT Mrid from MENU where Dishname = %s", (prev_items[0],))
            cart_rest = cur.fetchall()
            cart_rest = list(itertools.chain(*cart_rest))
            cur.execute("SELECT Rname from RESTAURANT where Rid = %s", ((cart_rest)[0],))
            rname = cur.fetchall()
            print("here")
            rname = list(itertools.chain(*rname))[0]
        if request.method == 'POST':
            dname = request.form['dname']
            price = request.form['price']
            rid = request.form['rid']
            qty = request.form['quantity']
            cid = request.form['cid']
            #print(dname, price, rid, qty)
            cur.execute("SELECT Rname  FROM RESTAURANT WHERE Rid = %s", (rid,))
            row = cur.fetchall() 
            row1 = [''.join(i[0])  for i in row]
            rname = row1[0]
            #print(row1)
            #print("prev", prev_items)
            if cart_rest != 0:
                if (int(session['rid']) not in  cart_rest):
                    return render_template('error.html', error="Your cart has dishes from other restaurant, clear cart to proceed")
            cur.execute("INSERT INTO CITEMS VALUES(%s, %s, %s, %s);", (dname, price, cid, qty))
            db.commit() #to commit changes
        cur.execute("SELECT * from CITEMS where Ccart_id=%s", (cid,)) 
        items = cur.fetchall()
        items = [[''.join(i[0]), i[1], i[3]]  for i in items]
        session['items'] = items
        cur.execute("SELECT SUM(Ciprice*ciqty)  FROM CITEMS WHERE Ccart_id = %s;", (cid,))
        total = cur.fetchall()[0][0]
        #print("total", total)
        cur.execute("SELECT Code, Maxdisc from COUPON where Exp_date > now() and Minord < %s", (total,))
        coupons = cur.fetchall()
        coupons = [[''.join(i[0]), i[1]]  for i in coupons]
        coupons.append(['No Coupons', 0])
        #print(coupons)
        cp = ['Clear cart', 'Proceed to pay']
        return render_template('cart.html', items = items, length=len(items),\
            total=total, coupons=coupons, num=len(coupons), cp = cp, cp_len = len(cp), restaurant=rname)
    except Exception as e:
        return render_template("error.html", error=e)   
@app.route('/confirm_order', methods=['GET', 'POST'])
def confirm_order():
    disc = 0
    try:
        if request.method == 'POST':
            cid = session['id']
            cp = request.form['cp']
            print(cp)
            if cp == 'Clear':
                cur.execute("DELETE FROM CITEMS WHERE Ccart_id = %s;", (session['id'],))
                db.commit()
                return redirect('/cust_home')
            disc = float(request.form['discount'])
            if request.form['total'] == 'None':
                return render_template("error.html", error = "Empty cart!!")
            total = float(request.form['total'])
            session['coupon_code'] = request.form['coupon_code']
            print(disc, type(disc))
        cur.execute("SELECT * from CITEMS where Ccart_id=%s", (cid,)) 
        items = cur.fetchall()
        items = [[''.join(i[0]), i[1], i[3]]  for i in items]
        cur.execute("SELECT SUM(Ciprice*ciqty)  FROM CITEMS WHERE Ccart_id = %s;", (cid,))
        total = cur.fetchall()[0][0]
        session['total'] = total - disc
        mode = ['Cash', 'Card']
        return render_template('confirm_order.html', items=items, length=len(items),\
            total=total, disc= disc, final_amount=total-disc, mode=mode, modes=2)
    except Exception as e:
        return render_template("error.html", error=e)
@app.route('/order', methods=['GET', 'POST']) 
def orders():
    if request.method == "POST":
        mode = request.form['mode']
        cur.execute("DELETE FROM CITEMS WHERE Ccart_id = %s;", (session['id'],))
    cur.execute("SELECT COUNT(*) FROM ORDER_;")
    row = cur.fetchall()
    row1 = list(itertools.chain(*row))
    oid = row1[0] + 1
    session['oid'] = oid
    cur.execute("Select Odid from ORDER_;")
    busy = cur.fetchall()
    busy = list(itertools.chain(*busy))
    #print(busy)
    did = 1
    for i in range(1, oid):
        if i not in busy:
            did = i
            break
    session['did'] = did
    cur.execute("SELECT COUNT(*) FROM TRANSACTION_;")
    num_transactions = cur.fetchall()
    #print(num_transactions)
    num_transactions = list(itertools.chain(*num_transactions))
    tid = num_transactions[0] + 1
    #print(num_transactions)
    #print("tid****", tid)
    cur.execute("INSERT INTO ORDER_ VALUES(%s, %s, %s);", (oid, did, session['rid'] ))
    items = session['items']
    for i in range(len(items)):
        cur.execute("INSERT INTO ITEMS VALUES(%s, %s, %s, %s)", (items[i][0], items[i][1], oid, items[i][2]) )
    cur.execute("select * from citems where Ccart_id =  %s;", (session['id'],))
    r = cur.fetchall()
    print("Cart", r)
    cur.execute("INSERT INTO TRANSACTION_ VALUES(%s, %s, %s);", (tid, session['total'], mode))
    cur.execute("INSERT INTO MAKES VALUES(%s, %s, %s, now());",(session['id'], oid, tid))
    if session['coupon_code'] != 'No Coupons':
        cur.execute("INSERT INTO APPLIES_ON VALUES(%s, %s, %s)", (session['id'], oid, session['coupon_code']))
    db.commit()
    '''cur.execute("select * from applies_on;")
    r = cur.fetchall()
    print(r)'''
    cur.execute("SELECT Dfname, Dlname FROM DELIVERY_PERSON WHERE Did = %s;", (did,))
    dp = cur.fetchall()
    dp = list(itertools.chain(*dp))
    cur.execute("SELECT Rname from RESTAURANT where Rid = %s", (session['rid'],))
    rest = cur.fetchall()
    rest = list(itertools.chain(*rest))
    cur.execute("SELECT Oid_history from orders where Ocid=%s;", (session['id'],))
    orders = cur.fetchall()
    orders = list(itertools.chain(*orders))
    #print("orders", orders)
    history = []
    for i in range(len(orders)):
        cur.execute('SELECT Orid, Iname, Iprice, iqty from order_ join items on Oid_  = Ioid and Oid_ = %s;', (orders[i],))
        it = cur.fetchall()
        it = list(itertools.chain(*it)) 
        cur.execute("SELECT Rname from RESTAURANT where Rid = %s", (it[0],))
        r = cur.fetchall()
        #print("rname***", r)
        r = list(itertools.chain(*r)) [0]
        history += [[r, it[1], it[2], it[3]]]
        #print("history", history)
    return render_template('orders.html', items=items, length=len(items),\
         dp=dp, restaurant=rest[0], total= session['total'], history= history, h_len = len(history))

@app.route('/delivered', methods=['GET', 'POST'])
def delivered():
    if request.method == 'POST':
        cur.execute('UPDATE ORDER_ SET Odid = %s where Oid_ = %s;', (0, session['oid']))
        cur.execute('INSERT INTO ORDERS VALUES(%s, %s)', (session['oid'], session['id']))
        db.commit()
    return render_template('review.html')

@app.route('/menu', methods = ['POST', 'GET'])
def menu():
    if request.method == 'POST':
        rid = int(request.form['items'])
        cid = int(request.form['cid'])
        session['rid'] = rid
    cur.execute("SELECT Dishname, Mprice, Type_, Mrid  FROM MENU, RESTAURANT WHERE Mrid = Rid AND Rid = %s", (session['rid'],))
    row = cur.fetchall() 
        #print(row)
    row1 = [[''.join(i[0]), i[1], ''.join(i[2]), i[3] ]  for i in row]
        #print(row1)
    cur.execute('SELECT COUNT(*) AS NUMBER_OF_ORDERS FROM CITEMS where Ccart_id=%s;',(session['id'],))
    qty = cur.fetchall()
    qty = qty[0][0]
    return render_template('menu.html', items = row1, length=len(row1), qty=qty, cid=session['id'])

@app.route('/after_rating', methods = ['POST'])
def after_rating():
    if request.method == 'POST':
        rrating = request.form['rrating']
        drating = request.form['dprating']
        cur.execute('SELECT Rating, rreviews from RESTAURANT where rid = %s;', (session['rid'],))
        r = cur.fetchall()
        r = list(itertools.chain(*r)) 
        print("before", r[0])
        #print(r[0], r[1], rrating, type(r[0]), type(r[1]), type(rrating))
        rrating = round((float(r[0]) * r[1] + float(rrating)) / (r[1] + 1), 1)
        print("after_rest", rrating)
        cur.execute('SELECT Drating, dreviews from DELIVERY_PERSON;')
        d = cur.fetchall()
        d = list(itertools.chain(*d)) 
        print("before", d[0])
        print(d[0], d[1], drating)
        drating = round((float(d[0]) * d[1] + float(drating)) / (d[1] + 1), 1)
        print("after_dp", drating)
        cur.execute('UPDATE RESTAURANT SET Rating = %s WHERE rid = %s;', (rrating, session['rid'],))
        db.commit()
        cur.execute('UPDATE DELIVERY_PERSON SET Drating = %s WHERE did = %s;', (drating, session['did'],))
        cur.execute('''
            UPDATE DELIVERY_PERSON SET REMARKS = 
            CASE
            WHEN  Drating > 4 AND Drating <= 5 THEN 'EXPERT'
            WHEN  Drating > 3 AND Drating <= 4 THEN 'PROFICIENT'
            WHEN  Drating > 2 AND Drating <= 3 THEN 'COMPETENT'
            WHEN  Drating > 1 AND Drating <= 2 THEN 'SATISFACTORY'
            WHEN  Drating >= 0 AND Drating <= 1 THEN 'NOVICE'
            END;
        ''')
        db.commit()
        return redirect('/cust_home')

@app.route('/')
def login():
    return render_template('login.html')
    
@app.route('/homepage', methods = ['POST'])
def homepage():
    if request.method == 'POST':
        id = request.form['phone']
        password = request.form['password']
        usertype = request.form['typeofuser']
        print(id, password, usertype)
        #Customer Validation
        if usertype == 'Customer':
            cur.execute("SELECT cpassword, Cid from Customer WHERE Cphone = %s", (id,))
            row = cur.fetchall() #row = [('password')]
            #Invalid email go back to login page -- Find a way to say "Invalid ID"
            if len(row) == 0:
                return render_template('login.html')
            row1 = list(itertools.chain(*row))      #Convert list of tuple to list
            #Check if passwords are equal
            #print(row1)
            if row1[0] == password:
                session['id'] = row1[1]
                return redirect('/cust_home') #changed
            print("incorrect")
            return render_template("login.html", error="Incorrect password!!")
        if usertype == 'Delivery Person':
            cur.execute('SELECT dpassword, Did from Delivery_Person WHERE Dphone = %s', (id,))
            row = cur.fetchall()
            if len(row) == 0:
                return render_template('login.html')
            row1 = list(itertools.chain(*row))
            #Check if passwords are equal
            if row1[0] == password:
                session['del_id'] = row1[1]
                return redirect('/delivery_profile')   #redirect to delivery person's homepage
            return render_template("login.html", error="Incorrect password!!")
        if usertype == 'Restaurant Owner':
            cur.execute('SELECT rpassword, Rid from Restaurant WHERE Rphone = %s', (id,))
            row = cur.fetchall()
            if len(row) == 0:
                return render_template('login.html')
            row1 = list(itertools.chain(*row))
            #Check if passwords are equal
            if row1[0] == password:
                session['rest_id'] = row1[1]
                return redirect('/employee/restuarent')
            return render_template("login.html", error="Incorrect password!!")

@app.route('/register', methods = ['POST'])
def register():
    if request.method == 'POST':
        usertype = request.form['choice']
        if usertype == 'Customer':
            return render_template('newCustomer.html')
        elif usertype == 'Delivery Person':
            return render_template('newDelivery.html')
        elif usertype == 'Restaurant Owner':
            return render_template('newRestaurant.html')
        else:
            return render_template('login.html')

@app.route('/registerCustomer', methods = ['POST'])
def registerCustomer():
    if request.method == 'POST':
        cfname = request.form['cfname']
        clname = request.form['clname']
        cphone = request.form['cphone']
        caddress = request.form['caddr']
        cemail = request.form['cemail']
        cpassword = request.form['cpassword']
        #Find out ID
        cur.execute("SELECT COUNT(*) FROM CUSTOMER;")
        row = cur.fetchall()
        row1 = list(itertools.chain(*row))
        cid = row1[0] + 1
        print(cid, cfname)
        session['id'] = cid
        cur.execute("SELECT Cphone, Email from CUSTOMER")
        cpe = cur.fetchall()
        c_ph = [''.join(i[0]) for i in cpe]
        c_mail = [''.join(i[1]) for i in cpe]
        print("reg customer", c_ph, c_mail, cphone, cemail)
        if cphone not in c_ph and cemail not in c_mail: 
            cur.execute("INSERT INTO CUSTOMER VALUES(%s, %s, %s, %s, %s, %s, %s);", (cid, cfname, clname, caddress, cphone, cemail, cpassword))
            db.commit()
            #Create Cart for Customer
            cur.execute("INSERT INTO CART VALUES(%s, %s);", (cid, cid))
            db.commit()
            #After Registration move to homepage
            return redirect('/cust_home')
        else:
            return render_template("error.html", error="email/phone number already exists!")

@app.route('/registerDelivery', methods = ['POST'])
def registerDelivery():
    if request.method == 'POST':
        dfname = request.form['dfname']
        dlname = request.form['dlname']
        dphone = request.form['dphone']
        dpassword = request.form['dpassword']
        dlocation = request.form['dlocation']
        vacStatus = bool(request.form['inlineRadioOptions'])
        cur.execute("SELECT COUNT(*) FROM DELIVERY_PERSON;")
        row = cur.fetchall()
        row1 = list(itertools.chain(*row))
        did = row1[0] + 1
        print(did, dfname)
        session['del_id'] = did
        cur.execute("SELECT Dphone from DELIVERY_PERSON")
        dpe = cur.fetchall()
        d_ph = [''.join(i[0]) for i in dpe]
        print("del customer", d_ph)
        if dphone not in d_ph: 
            cur.execute("INSERT INTO DELIVERY_PERSON(Did, Dfname, Dlname, Dphone, Vaccine_status, Temp, Dlocation, dpassword) VALUES(%s, %s, %s, %s, %s, 097.9, %s, %s);", (did, dfname, dlname, dphone, vacStatus, dlocation, dpassword))
            db.commit()
            return redirect("/delivery_profile")
        else:
            return render_template("error.html", error="Phone number already exists!")

@app.route('/registerRestaurant', methods = ['POST'])
def registerRestaurant():
    if request.method == 'POST':
        rname = request.form['Rname']
        rphone = request.form['Rphone']
        raddr = request.form['Raddr']
        rcuisine = request.form['Rcuis']
        rpassword = request.form['rpass']
        rmain = int(request.form['inlineRadioOptions'])
        mrphone = request.form['MRphone']
        cur.execute("SELECT COUNT(*) FROM RESTAURANT;")
        row = cur.fetchall()
        row1 = list(itertools.chain(*row))
        rid = row1[0] + 1
        print(rid, rname)
        ###Calculation of Main RID
        session['rest_id'] = rid
        if rmain == 1:
            rmain = rid
        else:
            cur.execute("SELECT rid FROM RESTAURANT WHERE rphone = %s;", (mrphone,))
            row2 = cur.fetchall()
            row3 = list(itertools.chain(*row2))
            rmain = row3[0]
        temp = []
        temp.append(rid)
        cur.execute("SELECT Rphone from RESTAURANT")
        rpe = cur.fetchall()
        r_ph = [''.join(i[0]) for i in rpe]
        print("reg rest", r_ph)
        if rphone not in r_ph: 
            cur.execute("INSERT INTO RESTAURANT(Rid, Rname, Rphone, Raddress, Cuisine, Rating, Main_rid, Rpassword) VALUES(%s, %s, %s, %s, %s, 0.0, %s, %s);", (rid, rname, rphone, raddr, rcuisine, rmain, rpassword))
            db.commit()
            return render_template('newMenu.html', items = temp)
        else:
            return render_template("error.html", error="Phone number already exists!")
        

@app.route('/newMenuItem', methods = ['POST'])
def newMenuItem():
    if request.method == 'POST':
        rid = int(request.form['rid'])
        dname = request.form['dname']
        mprice = float(request.form['mprice'])
        description = request.form['des']
        type = request.form['inlineRadioOptions']
        #Insert Menu Items
        cur.execute("INSERT INTO MENU VALUES(%s, %s, %s, %s, %s);", (dname, rid, mprice, type, description))
        db.commit()
        temp = []
        temp.append(rid)
        ###Keep taking new items until create menu is pressed
        return render_template('newMenu.html', items = temp)

@app.route('/createMenu', methods = ['POST'])
def createMenu():
    if request.method == 'POST':
            return redirect('/employee/restuarent')   

#changed

@app.route('/employee/orders', methods=['GET'])
def order():
    print(session['rest_id'])
    cur.execute("SELECT Oid_, Dfname, Dlname FROM ORDER_, DELIVERY_PERSON WHERE Odid = did and  Orid = %s", (session['rest_id'],))
    o = cur.fetchall()
    print(o)
    o_d = [[i[0], ''.join(i[1]), ''.join(i[2])] for i in o]
    cur.execute("SELECT DISTINCT Iname, iqty from ORDER_, ITEMS WHERE Ioid = Oid_ and Orid = %s", (session['rest_id'],))
    it= cur.fetchall()
    
    item = [[''.join(i[0]), i[1]] for i in it]
    print(item)
    return render_template('employee_order.html', o_d=o_d, length=len(o_d), item=item, it_len=len(item))


@app.route('/update/<id>', methods=['POST', 'GET'])
def update_(id):
    if request.method == 'POST':
        Mprice = request.form['Mprice']
        print(session['dish'])
        cur.execute(
            "UPDATE MENU SET Mprice = %s  WHERE Mrid = %s and Dishname =%s", (Mprice, session['rest_id'], session['dish']))
        flash('Food item Updated Successfully')
        cur.execute(
            "SELECT Dishname, Mprice, Type_, Mrid  FROM MENU, RESTAURANT WHERE Mrid = Rid AND Rid = %s", (session['rest_id'],))
        row = cur.fetchall()
        # print(row)
        row1 = [[''.join(i[0]), i[1], ''.join(i[2]), i[3]] for i in row]
        print(row1)
        db.commit()
        ud = ['update','delete']
        return render_template("employee_rest.html", items=row1, length=len(row1), ud=ud, len_ud=len(ud))
    return redirect(url_for('order'))


@app.route('/edit/<id>', methods=['POST', 'GET'])
def get_employee(id):
    if request.method == 'POST':
        print(request.form['ud'])
        session['dish'] = request.form['dishname']
        if request.form['ud'] == 'delete':
            cur.execute('DELETE FROM MENU WHERE Mrid = %s and Dishname = %s', (id,session['dish']))
            db.commit()
            flash('Food Item Removed Successfully')
            return redirect(url_for('employee_rest')) 
        session['dish'] = request.form['dishname']
        print("dishnamae", session['dish'])
    cur.execute('SELECT * FROM MENU WHERE Mrid = %s', (id))
    data = cur.fetchall()
    # cur.close()
    data1 = [[i[0], i[1], i[2], i[3]] for i in data]
    print(data1)
    return render_template('edit.html', items=data1, id=id)





@app.route('/employee/restuarent', methods=['GET', 'POST'])
def employee_rest():
    cur.execute(
        "SELECT Dishname, Mprice, Type_, Mrid  FROM MENU, RESTAURANT WHERE Mrid = Rid AND Rid = %s", (session['rest_id'],))
    row = cur.fetchall()
    print(row)
    row1 = [[''.join(i[0]), i[1], ''.join(i[2]), i[3]] for i in row]
    # print(row1)
    ud = ['update','delete']    
    rid = session['rest_id']
    #    return render_template('menu.html', items = row1, length=len(row1))
    return render_template("employee_rest.html", items=row1, length=len(row1), ud=ud, len_ud=len(ud), rid = rid)
    
@app.route("/additem", methods = ['GET', 'POST'])
def add_item():
    if request.method =='POST':
        rid = request.form['rid']
        items = [rid]
        return render_template("newMenu.html", items=items)

@app.route('/delivery', methods=['GET'])
def delivery_home():
    cur.execute(
        '''SELECT Fname, Cphone, CAddress, Rname, Rphone, Raddress
FROM (RESTAURANT JOIN (ORDER_ JOIN (CUSTOMER JOIN MAKES ON Cid = Mcid) ON Oid_ = Moid) ON Rid = Orid)
WHERE Odid = %s;''', (session["del_id"],))
    row = cur.fetchall()
    # print(row)
    row1 = [[''.join(i[0]), ''.join(i[1]), ''.join(i[2]), ''.join(i[3]), ''.join(i[4]), ''.join(i[5])] \
        for i in row]
    return render_template('delivery_home.html', delivery=row1, length=len(row1))


@app.route('/delivery_profile', methods=['GET'])
def delivery_profile():
    cur.execute(
        "SELECT Did,Dfname,Dlname,Dphone,Vaccine_status,Temp,Drating, remarks FROM DELIVERY_PERSON WHERE Did=%s ", (session['del_id'],))
    row = cur.fetchall()
    # print(row)
    row1 = [[i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7]] for i in row]
    return render_template('delivery_profile.html', delivery=row1, length=len(row1))


@app.route('/edit_profile/<id>', methods=['POST', 'GET'])
def edit_delivery(id):
    cur.execute('SELECT * FROM DELIVERY_PERSON WHERE Did = %s', (session['del_id'],))
    data = cur.fetchall()
    # cur.close()
    data1 = [[i[0], i[1], i[2], i[3], i[4]] for i in data]
    print(data1)
    return render_template('edit_profile.html', items=data1, id=id)


@app.route('/update_profile/<id>', methods=['POST', 'GET'])
def update_profile(id):
    try:
        if request.method == 'POST':
            Dphone = request.form['Dphone']
            print(session['del_id'])
            cur.execute("SELECT Dphone from DELIVERY_PERSON")
            phone = cur.fetchall()
            phone = list(itertools.chain(*phone))
            print("phone nos", phone)
            if Dphone not in phone:
                cur.execute("UPDATE DELIVERY_PERSON SET Dphone = %s WHERE Did = %s;",(Dphone, session['del_id'])) 
                cur.execute("SELECT * froM DELIVERY_PERSON  WHERE Did = %s;",(session['del_id'],)) 
                        
                dp = cur.fetchall()
                dp = list(itertools.chain(*dp))
                dp = [dp]
                print(dp)
                flash('Delivery person details Updated Successfully')
                db.commit()
                return render_template('delivery_profile.html', delivery=dp, length=len(dp))
            else:
                return render_template("error.html", error="Phone number already exists")
        return redirect(url_for('delivery_profile'))
    except Exception as e:
        return render_template("error.html", error=e)

@app.route('/logout', methods=['POST', 'GET'])
def logout():
    return redirect('/')

if __name__ == "__main__":
    app.secret_key = 'secret'
    app.run(host='127.0.0.1', debug=True)


