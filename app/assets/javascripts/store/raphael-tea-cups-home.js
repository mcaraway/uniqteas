var selected_teas = [];
var selected_teas_percentages = [34, 33, 33];
var selected_teas_count = 0;

var process_category_home = function(category) {
	var div = document.getElementById(category.name.replace(" ", "_").toLowerCase() + "_cups");

	var listElement = document.createElement("ul");
	for (var tea = 0; tea < category.teas.length; tea++) {
		var listItem = create_listItem_home(category.teas[tea]);
		listElement.appendChild(listItem);
	}
	div.appendChild(listElement);
	var image = document.createElement("div");
	image.innerHTML = "<img src = '/assets/" + category.name.replace(" ", "") + "Cup.png' width='90' height='90'> <br />";
	div.appendChild(image);

	var categoryName = document.createElement("h2");
	categoryName.innerHTML = category.name + "s";

	div.appendChild(categoryName);

};

var create_listItem_home = function(tea) {
	var listItem = document.createElement("li");
	listItem.setAttribute("id", tea.tea_name);
	listItem.setAttribute("title", tea.description);
	listItem.setAttribute("style", "font-size:16px;");
	listItem.innerHTML = tea.tea_name;

	listItem.onclick = function() {
		selected_teas[selected_teas.length] = tea;
		selected_teas_count++;

		window.location.href = "/blendit?flavor1=" + tea.tea_name
	};

	return listItem;
};

var setup_home = function() {

	var width = 950, height = width, font_size = width * 0.02;

	for ( j = 0; j < json.categories.length; j++) {
		process_category_home(json.categories[j].category);
	}
};

