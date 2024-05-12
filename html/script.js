window.addEventListener("message", function(event){
    let data = event.data;

    if(data.type === "ui") {
        $(".main-container").show().fadeIn(600)
    }

    if(data.type === "cData") {
        $(".moneycash").html(data.bani)
        $(".name").html(data.nume)
        $(".namestimate").html(data.nume)
    }

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $(".main-container").fadeOut(600)
            $.post('http://vd_banking/exit', JSON.stringify({}));
            return
        }
    };
});

function withdraw() {
    let v = $("#withdrawText").val();
    if(!isNaN(v)) {
        if(v > 0) {
            $.post('http://vd_banking/withdraw', JSON.stringify({
                text: v,
            }));
        }
    } else {
        $(".main-container").fadeOut(600)
        $.post('http://vd_banking/exit', JSON.stringify({}));
    }
}

function deposit() {
    let v = $("#depositText").val();
    if(!isNaN(v)) {
        if(v > 0) {
            $.post('http://vd_banking/deposit', JSON.stringify({
                text: v,
            }));
        }
    } else {
        $(".main-container").fadeOut(600)
        $.post('http://vd_banking/exit', JSON.stringify({}));
    }
}

function transfer() {
    let id = $("#transferId").val();
    let v = $("#transferNumber").val();
    if(!isNaN(v) && !isNaN(id)) {
        if(v > 0 && id > 0) {
            
            $.post('http://vd_banking/transfer', JSON.stringify({
                id: id,
                value: v,
            }))

        }
    } else {
        $.post('http://vd_banking/exit', JSON.stringify({}));
        $(".main-container").fadeOut(600)
    }
}