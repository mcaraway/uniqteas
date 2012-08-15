
Raphael.fn.pieChart = function (width, height, cx, cy, r, stroke, font_size, flavor_input_id) {
	var paper = this, 
		rad = Math.PI / 180, 
		outer_rad_mult = 1.7,
		chart = this.set(),
		outer_pie = [],
		inner_pie = [],
		outer_text = [],
		inner_text = [],
		curr_category = -1,
		hiding = false,
		inner_selected_pie,
		selected_image,
		ms = 500;
	
	/* draw a pie slice as a path */
	function pie_slice(cx, cy, r, startAngle, endAngle, params) {
		var x1 = cx + r * Math.cos(-startAngle * rad),
		x2 = cx + r * Math.cos(-endAngle * rad),
		y1 = cy + r * Math.sin(-startAngle * rad),
		y2 = cy + r * Math.sin(-endAngle * rad);
		return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
	}
	
	var angle = 0,
		total = 0,
		start = 0,
		is_outer_visible = false;
		
	/* used to draw the inner circle pie slices based on the data in the json data*/
	var process_inner = function (j) {
		var category = json.categories[j],
		value = json.categories[j].percent,
		angleplus = 360 * value / total,
		popangle = angle + (angleplus / 2),
		bcolor = Raphael.hsb(start, .75, 1),
		delta = 30,
		color = Raphael.getRGB(category.backgroundcolor),
		tcolor = Raphael.hsb(0, 0, 0),
		p = pie_slice(cx, cy, r, angle, angle + angleplus, {fill: angle + (angleplus/2)+"-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 3}),
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
				curr_category = j;
				show_outer(ms, true);
				
				category = json.categories[j];
				var r_angle = -((1/json.categories.length)*j)*360;
				inner_selected_pie.show();
				inner_selected_pie.stop().animate({transform: "s1.1,1.1,"+cx+","+cy+"r" +r_angle+"," + cx + "," + cy}, ms, "easeInOut");
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
				curr_category = j;
				show_outer(ms, true);
				
				category = json.categories[j];
				var r_angle = -((1/json.categories.length)*j)*360;
				inner_selected_pie.show();
				inner_selected_pie.stop().animate({transform: "s1.1,1.1,"+cx+","+cy+"r" +r_angle+"," + cx + "," + cy}, ms, "easeInOut");
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
		var category = json.categories[0],
		value = json.categories[0].percent,
		angleplus = 360 * value / total,
		p = pie_slice(cx, cy, r, 0, angleplus, {fill: "none", stroke: stroke, "stroke-width": 3});
		
		chart.push(p);
		return p;
	};
	
	/* used to draw the outer circle pie slices based on the data in the json data*/
	var process_outer = function (j) {
		var angleplus = 360 * 1 / json.num_flavors,
		popangle = angle + (angleplus / 2),
		color = Raphael.hsb(start, .75, 1),
		delta = 30,
		bcolor = Raphael.hsb(start, 1, 1),
		tcolor = Raphael.hsb(0, 0, 0),
		p = pie_slice(cx, cy, r, angle, angle + angleplus, {fill: angle + (angleplus/2)+"-" + bcolor + "-" + color, stroke: "#ddd", "stroke-width": 3, opacity: 0.5}),
		txt = paper.text(cx + (r + delta - 55) * Math.cos(-popangle * rad), cy + (r + delta - 55) * Math.sin(-popangle * rad), ".").attr({fill: tcolor, stroke: "none", opacity: 0.5, "font-size": font_size});
		
		outer_text[j] = txt;
		p.mouseover(function () {
			if (hiding)
				return;
			p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy, stroke: "#222"}, ms, "elastic");
			txt.stop().animate({opacity: 1}, ms, "elastic");
		}).mouseout(function () {
			if (hiding)
				return;
			p.stop().animate({transform: "", stroke: "#ddd"}, ms, "elastic");
			txt.stop().animate({opacity: 0.5}, ms);
		}).click(function() {
			if (hiding)
				return;
			
			select_outer_item(j);
		});
		txt.mouseover(function () {
			if (hiding)
				return;
			p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy, stroke: "#222"}, ms, "elastic");
			txt.stop().animate({opacity: 1}, ms, "elastic");
		}).mouseout(function () {
			if (hiding)
				return;
			p.stop().animate({transform: "", stroke: "#ddd"}, ms, "elastic");
			txt.stop().animate({opacity: 0.5}, ms);
		}).click(function() {
			if (hiding)
				return;
			select_outer_item(j);
		});
		angle += angleplus;
		chart.push(p);
		chart.push(txt);
		start += .1;
		p.scale(0,0,cx,cy);
		p.hide();
		txt.scale(0,0,cx,cy);
		return p;
	};
	
	var select_outer_item = function (tea_index) {
		// set the selected text
		document.getElementById(flavor_input_id).value = json.categories[curr_category].teas[tea_index].tea_name;
		// update the rect with the image
		var category = json.categories[curr_category];
		selected_image.attr({src: category.teas[tea_index].image});
		selected_image.show();
		
		// collapse the pies
		hide_outer(ms);
		hide_inner(ms);
	};
	
	var switch_outer = function (ms) {
		if (!is_outer_visible) {
			show_outer(ms);
		}
		else {	
			var category = json.categories[curr_category];
			
			for (var i = 0; i < outer_pie.length; i++) {
				// outer_pie[i].attr({fill: "url('"+category.teas[i].image+"') -200 -200"});
				outer_pie[i].attr({fill: category.backgroundcolor});
				outer_pie[i].stop().animate({transform: "s0.9,0.9," + cx + "," + cy }, 100, "easeInOut", function () {
					for (var i = 0; i < outer_pie.length; i++) {
						outer_pie[i].stop().animate({transform: "s1,1," + cx + "," + cy }, 300, "elastic");
						outer_text[i].attr({text: category.teas[i].tea_name});
					}
				});
			}
		}
	};
	
	var show_inner = function () {
		for (var i = 0; i < inner_pie.length; i++) {
			inner_pie[i].show();
			inner_pie[i].stop().animate({transform: "s1 1 " + cx + " " + cy}, 750, "elastic");
			
			inner_text[i].show();
			inner_text[i].stop().animate({transform: "s1 1 " + cx + " " + cy}, 750, "elastic");
		}
	}
	var show_outer = function (ms, allow_switch) {
		if (is_outer_visible && allow_switch) {
			switch_outer(ms);
			return;
		}
		var category = json.categories[curr_category];
		
		for (var i = 0; i < json.num_flavors; i++) {
			outer_pie[i].show();
			outer_text[i].show();
			
			outer_pie[i].attr({fill: category.backgroundcolor});
			outer_pie[i].stop().animate({transform: "s1,1," + cx + "," + cy }, ms, "easeInOut");
			outer_text[i].stop().animate({transform: "s1,1," + cx + "," + cy}, ms, "easeInOut", function () {		
				for (var i = 0; i < outer_pie.length; i++) {
					outer_text[i].attr({text: category.teas[i].tea_name, opacity: 0.5, transform: "s1,1," + cx + "," + cy});
				}
			});
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
			inner_pie[i].stop().animate({transform: "s0 0 " + cx + " " + cy}, 500, "elastic", cleanup(inner_pie[i], inner_text[i]));
			inner_text[i].stop().animate({transform: "s0 0 " + cx + " " + cy}, 500, "elastic");
			inner_text[i].attr({opacity: 0.3});
		}
		
		inner_selected_pie.stop().animate({transform: "s0,0,"+cx+","+cy}, ms, "elastic");
	};
	
	var hide_outer = function (ms) {
		if (!is_outer_visible)
			return;
		hiding = true;
		
		var cleanup = function(pie, text) {	
			pie.hide();
			text.hide();
		};
		
		for (var i = 0; i < outer_pie.length; i++) {
			outer_pie[i].stop().animate({transform: "s0,0," + cx + "," + cy }, ms, "easeInOut", cleanup(outer_pie[i], outer_text[i]));
			outer_text[i].animate({transform: "s0,0," + cx + "," + cy}, ms, "easeInOut");
			outer_text[i].attr({opacity: 0.3});
		}
		is_outer_visible = false;
	};
	
	for (var j = 0; j < json.categories.length; j++) {
		total += json.categories[j].percent;
	}
	
	var image_rect = paper.rect (20,20,width-40,width-40,5).attr({fill: "#fff", stroke: "#000", "fill-opacity": 1});
	
	selected_image = paper.image ("https://s3.amazonaws.com/carawaytea/images/uniqtea/SelectHere.png", 
				image_rect.getBBox().x+5,
				image_rect.getBBox().y+5,
				image_rect.getBBox().width-10,
			image_rect.getBBox().height-10);
	
	r = r * outer_rad_mult;
	for (j = 0; j < json.num_flavors; j++) {
		outer_pie[j] = process_outer(j);
	}

	r = r / outer_rad_mult;	
	for (j = 0; j < json.categories.length; j++) {
		inner_pie[j] = process_inner(j);
	}
	
	inner_selected_pie = process_selection("#444");
	inner_selected_pie.hide();
	inner_selected_pie.attr({transform: "s1.1,1.1," + cx + "," + cy});
			
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
		text_ids = [];
		
	var dragger = function (x, y, event) {
			this.ox = this.attr("x");
			this.oy = this.attr("y");
			this.animate({"fill-opacity": .2}, 500);
		},	 
		move = function (dx, dy, x, y, event) {
			var att = {x: this.ox + dx},
				orig_att = {x: this.getBBox().x};
				
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
	
	for (var i = 1; i < 100; i++ ) {
		var x = 20+(width-60)/100*i,
			y = i%5 == 0 ?12: 15,
			lineheight = i%5 == 0 ? 16 : 11,
			fill = i%5 ? "#999" : "#666";
		var tick = paper.rect(x,y,1,lineheight);
		tick.attr({stroke: fill});
	}
	var slider_bar = paper.rect (20,20,width-60,1,4).attr({fill: "#aaa", stroke: "#666", "fill-opacity": 1});
	
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

window.onload = function () {
	var width = 300, height = width, font_size = width*0.06;
	Raphael("holder1", width, height).pieChart(width, height, width/2, width/2, width/4, "#fff", font_size, "flavor1");
	Raphael("holder2", width, height).pieChart(width, height, width/2, width/2, width/4, "#fff", font_size, "flavor2");
	Raphael("holder3", width, height).pieChart(width, height, width/2, width/2, width/4, "#fff", font_size, "flavor3");
	Raphael("sliderbar", 920, 40).slider(920,40,3, font_size);
};
