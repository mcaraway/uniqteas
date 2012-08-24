var selected_teas = new Object();

Raphael.fn.pieChart = function (width, height, cx, cy, r, stroke, font_size, flavor_input_id) {
	var paper = this,
		rad = Math.PI / 180,
		outer_rad_mult = 1.8,
		chart = this.set(),
		outer_pie = [],
		inner_pie = [],
		outer_text = [],
		inner_text = [],
		curr_category = -1,
		hiding = false,

		inner_selected_pie,
		selected_image,
		ms = 500,
		maxFlavors = 0;

	/* draw a pie slice as a path */
	function pie_slice(cx, cy, r, startAngle, endAngle, params) {
		var x1 = cx + r * Math.cos(-startAngle * rad),
		x2 = cx + r * Math.cos(-endAngle * rad),
		y1 = cy + r * Math.sin(-startAngle * rad),
		y2 = cy + r * Math.sin(-endAngle * rad);
		return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
	}

	/* segment */
	paper.customAttributes.segment = function (cx, cy, r, startAngle, endAngle, clr) {
		var x1 = cx + r * Math.cos(-startAngle * rad),
		x2 = cx + r * Math.cos(-endAngle * rad),
		y1 = cy + r * Math.sin(-startAngle * rad),
		y2 = cy + r * Math.sin(-endAngle * rad),
		flag = (endAngle - startAngle) > 180,
		bcolor = Raphael.hsb(clr, .75, .8);

		return {
			path: [["M", cx, cy], ["L", x1, y1], ["A",r,r,0, +flag,0,x2,y2], ["z"]],
			fill: bcolor
		};
	};

	var angle = 0,
		total = 100,
		start = 0,
		is_outer_visible = false;

	/* used to draw the inner circle pie slices based on the data in the json data*/
	var process_inner = function (j) {
		var category = json.categories[j].category,
		value = 100/json.categories.length,
		angleplus = 360 * value / total,
		popangle = angle + (angleplus / 2),
		bcolor = Raphael.hsb(start, .75, 1),
		delta = 30,
		color = Raphael.hsb(category.backgroundcolor, .75, .8),
		tcolor = Raphael.hsb(0, 0, 0),
		p = pie_slice(cx, cy, r, angle, angle + angleplus, {fill: angle + (angleplus/2)+"-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 2}),
		txt = paper.text(cx + (r + delta - 55) * Math.cos(-popangle * rad), cy + (r + delta - 55) * Math.sin(-popangle * rad), category.name).attr({fill: tcolor, stroke: "none", opacity: 0.5, "font-size": font_size});

		inner_text[j] = txt;
		p.mouseover(function () {
			if (hiding)
				return;
			p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy}, ms, "elastic");
			txt.stop().animate({opacity: 1}, ms, "elastic");
		}).mouseout(function () {
			if (hiding)
				return;
			if (curr_category != j)
			{
				p.stop().animate({transform: "s 1 1 " + cx + " " + cy}, ms, "elastic");
				txt.stop().animate({opacity: 0.5}, ms);
			}
		}).click (function () {
			if (hiding)
				return;
			if (curr_category != j)
			{
				if (curr_category != -1) {
					inner_pie[curr_category].stop().animate({transform: "s1,1,"+ cx + "," + cy}, ms, "elastic");
				}
				switch_outer(ms, j);
			}
		});
		txt.mouseover(function () {
			if (hiding)
				return;
			p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy}, ms, "elastic");
			txt.stop().animate({opacity: 1}, ms, "elastic");
		}).mouseout(function () {
			if (hiding)
				return;
			if (curr_category != j)
			{
				p.stop().animate({transform: ""}, ms, "elastic");
				txt.stop().animate({opacity: 0.5}, ms);
			}
		}).click (function () {
			if (hiding)
				return;
			if (curr_category != j)
			{
				if (curr_category != -1) {
					inner_pie[curr_category].stop().animate({transform: "s1,1,"+ cx + "," + cy}, ms, "elastic");
				}

				switch_outer(ms, j);
			}
		});;
		angle += angleplus;
		chart.push(p);
		chart.push(txt);
		start += .1;
		p.scale(0,0,cx,cy);
		p.hide();
		txt.scale(0,0,cx,cy);
		return p;
	};

	/* used to draw the selection pie slice*/
	var process_selection = function (stroke) {
		var value = 100/json.categories.length,
		angleplus = 360 * value / total,
		p = pie_slice(cx, cy, r, 0, angleplus, {fill: "none", stroke: stroke, "stroke-width": 3});

		chart.push(p);
		return p;
	};

	/* used to draw the outer circle pie slices based on the data in the json data*/
	var process_outer = function (j) {
		var angleplus = 360 * (1 / maxFlavors),
		popangle = angle + (angleplus / 2),
		color = Raphael.hsb(start, .75, 1),
		delta = 30,
		bcolor = Raphael.hsb(start, 1, 1),
		tcolor = Raphael.hsb(0, 0, 0),
		p = paper.path().attr({segment: [cx, cy, r, angle, angle + angleplus, bcolor], stroke: "#fff", "stroke-width": 2});

		//p.attr({fill: angle + (angleplus/2)+"-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 3});
		//p = pie_slice(cx, cy, r, angle, angle + angleplus, {fill: angle + (angleplus/2)+"-" + bcolor + "-" + color, stroke: "#ddd", "stroke-width": 3, opacity: 0.5}),

		var txt = paper.text(cx + (r + delta) * Math.cos(-popangle * rad), cy + (r + delta) * Math.sin(-popangle * rad), ".").attr({fill: tcolor, stroke: "none", opacity: 0.5, "font-size": font_size});

		outer_text[j] = txt;
		p.mouseover(function () {
			if (hiding || showing)
				return;
			p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy, stroke: "#222"}, ms, "elastic");
			txt.stop().animate({opacity: 1}, ms, "elastic");
		}).mouseout(function () {
			if (hiding || showing)
				return;
			p.stop().animate({transform: "", stroke: "#ddd"}, ms, "elastic");
			txt.stop().animate({opacity: 0.5}, ms);
		}).click(function() {
			if (hiding || showing)
				return;

			select_outer_item(j);
		});

		txt.mouseover(function () {
			if (hiding || showing)
				return;
			p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy, stroke: "#222"}, ms, "elastic");
			txt.stop().animate({opacity: 1}, ms, "elastic");
		}).mouseout(function () {
			if (hiding || showing)
				return;
			p.stop().animate({transform: "", stroke: "#ddd"}, ms, "elastic");
			txt.stop().animate({opacity: 0.5}, ms);
		}).click(function() {
			if (hiding || showing)
				return;
			select_outer_item(j);
		});
		angle += angleplus;
		chart.push(p);
		chart.push(txt);
		start += .1;
		p.scale(0,0,cx,cy);
		p.hide();
		txt.hide();
		return p;
	};

	var select_outer_item = function (tea_index) {
		// set the selected text
		document.getElementById(flavor_input_id).value = json.categories[curr_category].category.teas[tea_index].tea_name;
		// update the rect with the image
		selected_image.attr({src: json.categories[curr_category].category.teas[tea_index].image});
		selected_image.show();

		// update selected_teas
		selected_teas[flavor_input_id] = json.categories[curr_category].category.teas[tea_index];

		// collapse the pies
		hide_outer(ms,curr_category);
		hide_inner(ms);

		update_flavor_profile();
	};

	var switch_outer = function (ms, new_category) {
		show_outer(ms, new_category);
		curr_category = new_category;

		var r_angle = -((1/json.categories.length)*new_category)*360;
		inner_selected_pie.show();
		inner_selected_pie.stop().animate({transform: "s1.1,1.1,"+cx+","+cy+"r" +r_angle+"," + cx + "," + cy}, ms, "easeInOut");
	};

	var show_inner = function () {
		for (var i = 0; i < inner_pie.length; i++) {
			inner_pie[i].show();
			inner_pie[i].stop().animate({transform: "s1 1 " + cx + " " + cy}, 750, "elastic");

			inner_text[i].show();
			inner_text[i].stop().animate({transform: "s1 1 " + cx + " " + cy}, 750, "elastic");
		}
	}

	var show_outer = function (ms, cindex) {
		var category = json.categories[cindex].category,
			numFlavors = category.teas.length,
			start = 0,
			val = 360 / numFlavors,
			delta = -20;

		showing = true;

		for ( var i = 0; i < maxFlavors; i++ ) {
			var newTextX = cx + (r + delta) * Math.cos(-(start+(val / 2)) * rad),
				newTextY = cy + (r + delta) * Math.sin(-(start+(val / 2)) * rad);
				tx = newTextX - outer_text[i].attrs.x,
				ty = newTextY - outer_text[i].attrs.y,
				flag90 = (start + (val / 2)) > 90 && (start + (val / 2)) < 180 ?0:1,
				flag180 = (start + (val / 2)) > 180?0:1,
				rotation = flag180?-(start + (val / 2))+90:-(start + (val / 2))-90;
			outer_pie[i].show();
			outer_text[i].show();

			if (i < numFlavors) {
				var isLast = i == numFlavors-1;
				with ({pie: outer_pie[i], text: outer_text[i], isLastPie: isLast, tx: tx, ty: ty, rotation: rotation, tea_name: category.teas[i].tea_name}) {
					pie.animate({segment: [cx, cy, r, start, start + val, category.backgroundcolor],
						transform: "s1,1," + cx + "," + cy
						}, ms || 1500, "easeInOut", function(){
							if (isLastPie)
								showing = false;
						});


					text.animate({opacity: 0.0}, ms/2, "easeInOut", function() {
						text.attr({text: tea_name, transform: "s1,1," + cx + "," + cy});
						text.animate({transform: "t" + tx + "," + ty + "r" + rotation, opacity: 0.5}, ms/2, "easeInOut");
					});

					start += val;
				}
			}
			else {
				outer_pie[i].animate({segment: [cx, cy, r, 360, 360]}, ms || 1500, "easeInOut");
				outer_text[i].stop().animate({transform: "t" + tx + "," + ty}, ms, "easeInOut");
				outer_text[i].hide();
			}

		}

		is_outer_visible = true;
	};
	var hide_inner = function (ms) {
		hiding = true;
		var cleanup = function(pie, text) {
			curr_category = -1;
			hiding = false;
			pie.hide();
			text.hide();
		};

		for (var i = 0; i < inner_pie.length; i++) {
			with ({pie: inner_pie[i], text: inner_text[i]}) {
				var animation = Raphael.animation({transform: "s0 0 " + cx + " " + cy}, ms, "elastic", function() {
					cleanup(pie, text);
				});
				pie.stop().animate(animation);
				text.stop().animateWith(pie, animation, {transform: "s0 0 " + cx + " " + cy, opacity: 0.3}, ms, "elastic");
			}
		}

		inner_selected_pie.stop().animate({transform: "s0,0,"+cx+","+cy}, ms, "elastic");
	};

	var hide_outer = function (ms, category) {
		if (!is_outer_visible)
			return;
		hiding = true;

		var cleanup = function(pie, text) {
			pie.hide();
			text.hide();
			hiding = false;
		};
		for (var i = 0; i < outer_pie.length; i++) {
			outer_pie[i].stop().animate({transform: "s0,0," + cx + "," + cy }, ms, "easeInOut");
			outer_text[i].stop().animate({transform: "s0,0," + cx + "," + cy, opacity: 0.3}, ms, "easeInOut", cleanup(outer_pie[i],outer_text[i]));
		}
		is_outer_visible = false;
	};

	var padding = 10;
	var image_rect = paper.rect (padding,padding,width-(padding*2),width-(padding*2),5).attr({fill: "#fff", stroke: "#000", "fill-opacity": 1});

	selected_image = paper.image ("https://s3.amazonaws.com/carawaytea/images/uniqtea/SelectHere.png",
				image_rect.getBBox().x+5,
				image_rect.getBBox().y+5,
				image_rect.getBBox().width-10,
			image_rect.getBBox().height-10);

	r = r * outer_rad_mult;

	// calculate how many outer pies we need
	for (j = 0; j < json.categories.length; j++) {
		maxFlavors = json.categories[j].category.teas.length > maxFlavors ? json.categories[j].category.teas.length : maxFlavors;
	}


	for (j = maxFlavors-1; j >= 0; j--) {
		outer_pie[j] = process_outer(j);
	}

	r = r / outer_rad_mult;
	for (j = 0; j < json.categories.length; j++) {
		inner_pie[j] = process_inner(j);
	}

	inner_selected_pie = process_selection("#444");
	inner_selected_pie.hide();
	inner_selected_pie.attr({transform: "s1.1,1.1," + cx + "," + cy});

	r = r * outer_rad_mult;

	var circle = paper.image ("https://s3.amazonaws.com/carawaytea/images/uniqtea/TeaSelector.png",
		cx-20,
		cy-20,
		40,
		40);
	// paper.circle (cx,cy, 15).attr({fill: "#ccc", stroke: "#000", "fill-opacity": 1});


	circle.mouseover(function() {
		circle.attr({src: "https://s3.amazonaws.com/carawaytea/images/uniqtea/TeaSelectorHover.png"});
	}).mouseout(function() {
		circle.attr({src: "https://s3.amazonaws.com/carawaytea/images/uniqtea/TeaSelector.png"});
	}).click(function () {
		show_inner();
	});

	document.getElementById(flavor_input_id).onclick = function() {
		show_inner();
	};
	return chart;

};

Raphael.fn.slider = function(width, height, num_values, font_size) {
	var paper = this,
		slider = this.set(),
		sliders = [],
		text_ids = [],
		sliderWidth = width - 60,
		sliderStartX = 20,
		sliderEndX = sliderStartX + sliderWidth;

	var dragger = function (x, y, event) {
			this.ox = this.attr("x");
			this.oy = this.attr("y");
			this.animate({"fill-opacity": .2}, 500);
		},
		move = function (dx, dy, x, y, event) {
			var att = {x: this.ox + dx},
				orig_att = {x: this.getBBox().x};

			if (att.x  <= sliderStartX || att.x >= sliderEndX)
				return;

			this.attr(att);

			if (!checkBoundingBoxes())
				this.attr(orig_att);
			updatePercent();

		},
		up = function () {
			this.animate({"fill-opacity": 0}, 500);
		},
		checkBoundingBoxes = function() {
			for (i = 0; i < sliders.length-1; i++) {
				if (compareBB(sliders[i].getBBox(), sliders[i+1].getBBox()))
					return false;
			}
			return true;
		},
		compareBB = function(box,box2) {
			if (box.x2 > box2.x)
				return true;
		},
		updatePercent = function() {
			var start = slider_bar.getBBox().x,
				finalPercent = 100.0,
				percent = 0;
			for (var i = 0; i < sliders.length; i++) {
				percent = (((sliders[i].getBBox().x - start)/slider_bar.getBBox().width)*100).toFixed(0);

				var input = document.getElementById(text_ids[i]);
				input.value = percent+"%";
				start = sliders[i].getBBox().x;
				finalPercent -= percent;
			}
			var input = document.getElementById(text_ids[text_ids.length-1]);
			input.value = finalPercent.toFixed(0)+"%";

		},
		updateSliders = function() {
			var newX = 0, totalPercent=0;
			for (var i = 0; i < text_ids.length-1; i++) {
				var input = document.getElementById(text_ids[i]),
					strValue = input.value,
					intValue = parseInt(strValue.substring(0,strValue.length)),
					percentOfSlider = (intValue/100)*slider_bar.getBBox().width;

				totalPercent += intValue;
				newX += percentOfSlider;
				if ( i < sliders.length )
					sliders[i].attr({x: newX});

			}
			var input = document.getElementById(text_ids[text_ids.length-1]);
			input.value = (100-totalPercent).toFixed(0)+"%";
		},
		updatePercentValues = function() {
			for (var i = 0; i < text_ids.length-1; i++) {
				element = document.getElementById(text_ids[i]);
				if (element.value.indexOf("%") == -1)
					element.value = element.value + "%";
			}
		};

	var majorTick = 10;
	var minorTick = 5;
	for (var i = minorTick; i < 100; i+= minorTick ) {
		var x = 20+(width-60)/100*i,
			y = i%majorTick == 0 ?12: 15,
			lineheight = i%majorTick == 0 ? 16 : 11,
			fill = i%majorTick ? "#999" : "#666";
		var tick = paper.rect(x,y,1,lineheight);
		tick.attr({stroke: fill});
	}
	var slider_bar = paper.rect (sliderStartX,20,sliderWidth,1,4).attr({fill: "#aaa", stroke: "#666", "fill-opacity": 1});

	var rect_left = 0,
		rect_width = 80,
		offset = (width/(num_values))/2-(rect_width/2);
	for (var i = 0; i < num_values-1; i++) {
		sliders[i] = paper.image ("https://s3.amazonaws.com/carawaytea/images/uniqtea/SliderHandle.png",
			(width/(num_values))*(i+1),
			6,
			21,
			30);
		sliders[i].drag(move,dragger,up);
	}
	for (var i = 0; i < num_values; i++) {
		rect_left = ((width/(num_values))*(i)) + offset;

		var top = 40;

		text_ids[i] = "percent"+(i+1);
		document.getElementById(text_ids[i]).value = (100/num_values).toFixed(0)+"%";
		document.getElementById(text_ids[i]).onchange = updateSliders;
		document.getElementById(text_ids[i]).onblur = function() {
			updatePercentValues();
		}
	}

	return slider;
};

function update_flavor_profile() {
	var profiles = new Object();
	var keys = ["aroma","floral","fruity","nutty","savoury","spicy","sweetness","vegetal","woody"];
	for (var i = 0; i < keys.length; i++) {
		profiles[keys[i]] = 0;
	}

	for (var tea in selected_teas) {

		for (var i = 0; i < keys.length; i++) {
			var currTea = selected_teas[tea];
			var strValue = currTea.flavor_profile[keys[i]];
			var value = parseInt(selected_teas[tea].flavor_profile[keys[i]] );
			if (profiles[keys[i]] < value) {
				profiles[keys[i]] = value;
			}
		}
	}

	var profile_name_string = "";
	var profile_value_string = "";
	var table = document.getElementById('flavor_profile_table');

	if (table != null) {
		document.getElementById("flavor_profile_row").removeChild(table);
	}

	table = document.createElement('table');
	table.setAttribute('id','flavor_profile_table');
	table.setAttribute('style','width:100%;');
	var tbody = document.createElement('tbody');
	table.appendChild(tbody);

	for(var i = 0; i < keys.length ; i++) {
		if (profiles[keys[i]] != 0) {
			var row = document.createElement('tr');
			var nameCell = document.createElement('td');
			nameCell.setAttribute('style','width:20%;');
			var valueCell = document.createElement('td');

			row.appendChild(nameCell);
			row.appendChild(valueCell);

			nameCell.innerHTML = keys[i] + ": <br />";
			valueCell.innerHTML =  "<img src = '/assets/star_" + profiles[keys[i]] + ".png' width='90' height='35'> <br />";

			tbody.appendChild(row);
		}
	}


	document.getElementById("flavor_profile_row").appendChild(table);
}

window.onload = function () {
	var width = 310, height = width, font_size = width*0.04;

	Raphael("holder1", width, height).pieChart(width, height, width/2, width/2, width/4, "#fff", font_size, "flavor1");
	Raphael("holder2", width, height).pieChart(width, height, width/2, width/2, width/4, "#fff", font_size, "flavor2");
	Raphael("holder3", width, height).pieChart(width, height, width/2, width/2, width/4, "#fff", font_size, "flavor3");
	Raphael("sliderbar", 920, 40).slider(920,40,3, font_size);
};
