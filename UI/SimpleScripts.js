let firstCategory = true
let SimpleScriptsEinkaufswagen = []

function SimpleScriptsVersteckeProdukte() {
    $(".SimpleScriptsProdukte").hide();
}

document.addEventListener('DOMContentLoaded', function () {
    $("body").hide();
    
    function SimpleScriptsVersteckeProdukte() {
        $(".SimpleScriptsProdukte").hide();
    }
    
    function SimpleScriptsZeigeProdukteByKategorie(category) {
        $(".SimpleScriptsProdukte").each(function() {
            if ($(this).data('category') === category) {
                $(this).show();
            }
        });
    }
    
    $(".SimpleScripts-Kategorie-Button").click(function() {
        $(".SimpleScripts-Kategorie-Button").removeClass("Ausgewählt");
        $(this).addClass("Ausgewählt");
        var category = $(this).data('category');
        SimpleScriptsVersteckeProdukte();
        SimpleScriptsZeigeProdukteByKategorie(category);
    });
    
    window.addEventListener('message', function(event) {
        var item = event.data;
        
        if (item.clear == true) {
            $(".Produkt-List").empty();
            $(".SimpleScriptsSelect").empty();
        }
        
        if (item.display == true) {
            $("body").fadeIn("slow");
        }
        
        if (item.display == false) {
            $("body").fadeOut(100);
        }
    
        if (item.categoryName !== undefined) {
            if (firstCategory) {
                $(".SimpleScriptsSelect").append(`
                    <div class="boxselect" category="` + item.categoryName + `" onclick="SimpleScriptsZeigProdukteKategorie('` + item.categoryName + `')">
                        <div class="min-box">
                        <img src="assets/images/Boxen.svg"/ >			
                        </div>
                        <p class="namebox">` + item.categoryName + `</p>			
                    </div>
                `)
                SimpleScriptsZeigProdukteKategorie(item.categoryName)
                firstCategory = false;
                return;
            } 
            $(".SimpleScriptsSelect").append(`
                <div class="boxselect" category="` + item.categoryName + `" onclick="SimpleScriptsZeigProdukteKategorie('` + item.categoryName + `')">
                    <div class="min-box">
                        <img src="assets/images/Boxen.svg"/>			
                    </div>
                    <p class="namebox">` + item.categoryName + `</p>			
                </div>
            `)
        }  
        if (item.itemkategorie !== undefined) {
            $(".Produkt-List").append(`
                <div class="SimpleScriptsProdukte" data-category="` + item.itemkategorie + `" itemtype="` + item.type + `" itemname="` + item.name + `" category="` + item.category + `" onclick="SimpleScriptsAddWarenkorb('` + item.name + `', '` + item.type + `', '` + item.label + `', '` + item.price + `', '` + item.category + `')">
                    <p class="SimpleScriptsProduktName">` + item.label + `</p>
                    <p class="itemtype" style="display: none;">` + item.type + `</p>
                    <p class="itemcategory" style="display: none;">` + item.category + `</p>
                    <p class="itemname" style="display: none;">` + item.name + `</p>
                    <img src="./images/` + item.name + `.png" alt="">
                    <p class="SimpleScriptsProduktPreis">` + item.price + `<span>$</span></p>
                </div>
            `);
        }
        $(".SimpleScriptsProdukte img").draggable({
            helper: 'clone',
            revert: function(dropped) {
                if (!dropped) {
                    $(this).data("uiDraggable").originalPosition = {
                        top: 300,
                        left: 800
                    };
                    return true;
                } else {
                    return false;
                }
            },
            containment: ".container"
        });
    }); 
    $(document).ready(function() {
        $(".Warenkorb-List").droppable({
            accept: ".SimpleScriptsProdukte img",
            drop: function(event, ui) {
                var droppedItem = ui.helper; 
                var category = droppedItem.siblings('.itemcategory').text();
                var itemname = droppedItem.siblings('.itemname').text();
                var itemtype = droppedItem.siblings('.itemtype').text();
                var itemLabel = droppedItem.siblings('.SimpleScriptsProduktName').text();
                var itemPrice = parseFloat(droppedItem.siblings('.SimpleScriptsProduktPreis').text());
                SimpleScriptsAddWarenkorb(itemname, itemtype, itemLabel, itemPrice, category);
                droppedItem.show();
            }
        });
    });
});

function SimpleScriptsZeigProdukteKategorie(category) {
	$( ".SimpleScriptsSelect" ).children().each(function( index ) {
		$(this).removeClass("Ausgewählt")
		if($(this).attr("category") == category) {
			$(this).addClass("Ausgewählt")
		}
	})
	$( ".Produkt-List" ).children().each(function( index ) {
		$(this).hide()
		const att = $(this).attr('category')
		if (att == category) {
			$(this).show()
		}
	});
	SimpleScriptsUpdateWarenkorb()
}

function SimpleScriptsBuy(items, payment) {
    var data = {
        items: items,
        payment: payment
    };
    $.post('https://Simple_Shops/SimpleScriptsBuy', JSON.stringify(data));
    SimpleScriptsResetandClear();
}

document.onkeydown = function(event) {
    let data = event || window.event;
    if (data.key == "Escape") {
        $("body").fadeOut(100);
        $.post('https://Simple_Shops/exit');
        SimpleScriptsResetandClear(); 
    }
}

function SimpleScriptsResetandClear() {
    SimpleScriptsEinkaufswagen = [];
    SimpleScriptsUpdateWarenkorb();
    $(".SimpleScripts-Kategorie-Button").removeClass("Ausgewählt");
    SimpleScriptsVersteckeProdukte();
}

function SimpleScriptsCeckout(payment) {
    var data = {
        items: [],
        payment: payment 
    };
    for (var key in SimpleScriptsEinkaufswagen) {
        const item = key;
        if (SimpleScriptsEinkaufswagen[key].count > 0) {
            data.items.push({
                item: item,
                category: SimpleScriptsEinkaufswagen[key].category,
                amount: SimpleScriptsEinkaufswagen[key].count,
                type: SimpleScriptsEinkaufswagen[key].type
            });
        }
    }
    SimpleScriptsBuy(data.items, payment); 
    SimpleScriptsEinkaufswagen = [];
}

let SimpleScriptsProdukteAnzahl = 0; 
function SimpleScriptsUpdateWarenkorb() {
    let price = 0;
    $(".Warenkorb-Positionen").empty();
    if (Object.keys(SimpleScriptsEinkaufswagen).length === 0 || Object.values(SimpleScriptsEinkaufswagen).every(item => item.count === 0)) {
        $(".Warenkorb-Positionen").html(`
        <img src="Hand.png" alt="Bildbeschreibung" class="SimpleScriptsReinziehenBild">
        <p class='SimpleScriptsReinziehenText'>Du kannst Produkte reinziehen</p>`);        
        return;
    }
    SimpleScriptsProdukteAnzahl = 0;
    for (var key in SimpleScriptsEinkaufswagen) {
        const item = key;
        price += SimpleScriptsEinkaufswagen[key].count * SimpleScriptsEinkaufswagen[key].price;
        SimpleScriptsProdukteAnzahl += SimpleScriptsEinkaufswagen[key].count; 
        if (SimpleScriptsEinkaufswagen[key].count > 0) {
            $(".Warenkorb-Positionen").append(`
                <div class="SimpleScriptsWarenkorbProdukte">
                    <div class="SimpleScriptsWarenkorbProduktImage">
                        <img src="images/${item}.png" alt="">
                    </div>
                    <p class="SimpleScriptsWarenkorbProduktNamen">${SimpleScriptsEinkaufswagen[key].label}</p>
                    <p class="SimpleScriptsWarenkorbProduktAnzahl">X<span>${SimpleScriptsEinkaufswagen[key].count}</span></p>
                    <div class="SimpleScriptsWarenkorbButtons">
                        <button class="SimpleScriptsWarenkorbButtonMinus" onclick="SimpleScriptsRemove('${item}')">-</button>
                        <button class="SimpleScriptsWarenkorbButtonPlus" onclick="SimpleScriptsPlus('${item}')">+</button>
                    </div>
                    <img class="SimpleScriptsWarenkorbButtonLöschen" src="Loschen.png" alt="" onclick="SimpleScriptsRemoveWarenkorb('${item}')">
                    <div class="SimpleScriptsWarenkorbButtonLöschenKlasse"></div>
                </div>
            `);
        }
    }
    $(".SimpleScriptsTotalPrice").html(price + '<span>$</span>');
    $(".SimpleScriptsProdukteInsgesamt").html('<span>Produkte: </span>' + SimpleScriptsProdukteAnzahl); 
}

function SimpleScriptsRemoveWarenkorb(itemName) {
    SimpleScriptsEinkaufswagen[itemName].count = 0;
    SimpleScriptsUpdateWarenkorb();
}

function SimpleScriptsRemoveWarenkorb(itemName) {
	SimpleScriptsEinkaufswagen[itemName].count = 0
	SimpleScriptsUpdateWarenkorb()
}

function SimpleScriptsAddWarenkorb(itemName, itemType, itemLabel, itemPrice, category) {
    if (SimpleScriptsEinkaufswagen[itemName]) {
        SimpleScriptsEinkaufswagen[itemName].count += 1;
    } else {
        SimpleScriptsEinkaufswagen[itemName] = {
            count: 1,
            type: itemType,
            label: itemLabel,
            price: itemPrice,
            category: category
        };
    }
    SimpleScriptsUpdateWarenkorb();
}

function SimpleScriptsPlus(itemName) {
	if (SimpleScriptsEinkaufswagen[itemName]) {
		SimpleScriptsEinkaufswagen[itemName].count += 1
		SimpleScriptsUpdateWarenkorb()
	} 
}

function SimpleScriptsRemove(itemName) {
	if (SimpleScriptsEinkaufswagen[itemName]) {
		SimpleScriptsEinkaufswagen[itemName].count -= 1		
		SimpleScriptsUpdateWarenkorb()
	} 
}


