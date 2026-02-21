function post_Form() {
    console.log("Posting form...");
    var out = document.getElementById('resultPre');
    var form = document.getElementById('predictForm');
    var xhr = new XMLHttpRequest();
    var formData = new FormData(form);
    //open the request
    xhr.open('POST', '/predict');
    xhr.setRequestHeader("Content-Type", "application/json");
    console.log(Object.fromEntries(formData));
    //send the form data
    xhr.send(JSON.stringify(Object.fromEntries(formData)));
    out.innerHTML = "Loaded:" + JSON.stringify(Object.fromEntries(formData));
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            var response = JSON.parse(xhr.responseText);
            console.log(response["prediction"]);
            out.innerHTML = ""+ response["prediction"]+"";
            form.reset(); //reset form after AJAX success or do something else
        }
    }
    //Fail the onsubmit to avoid page refresh.
    return false;
}
console.log("main.js loaded");

// form.onsubmit = function (event) {
//     return postForm();
// }
setTimeout(() => {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/predict');
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            var response = JSON.parse(xhr.responseText);
            console.log(response["prediction"]);
            // out.innerHTML = response["prediction"];
			out.innerHTML = ""+ response["prediction"]+"";
            form.reset(); //reset form after AJAX success or do something else
        }
    }

    var btnSubmit = document.getElementById('submitBtn');
    btnSubmit.addEventListener("click", function (e) {
        console.log(this.className); // logs the className of myElement
        console.log(e.currentTarget === this); // logs `true`
        post_Form();
    });
}, 3000);
// const req = new XMLHttpRequest();
// req.addEventListener("load", reqListener);
// req.open("GET", "/predict");
// req.send();