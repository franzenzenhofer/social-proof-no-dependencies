#a simple social proof javascript that checks fb, pinterest, linkedin without any external dependencies (like jquery)

usage

    socialProof(url, class_name)

    #fetched sharecounts and writes it into the elements with the class "counter"
    socialProof('http://www.veganblatt.com/', 'counter')

if url is null it uses the URL of the og:url element
if og:url is not available, then is uses the canoncial
if the canonical is not avaialbe, it uses the window.top.location

    socialProof(null, 'counter')

if class_name is null, the counter is written to the console (if availalbe)

    socialProof()
    socialProof('http://www.veganblatt.com/')

with

    var _DEBUG_ = true;

you will get some debug output on the console

this code has a serious limitation: you can only call it once per page? otherwise I would have needed to re-invent dynamic callbacks, and I didn't want to do that yet (TODO)
