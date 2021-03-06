(function(a) {
	a.fn.PaRSS = function(m, c, b, l, n) {
		var i = this, g = {
			feed_url : m,
			item_count : c,
			date_format : b,
			show_descriptions : l,
			callback_function : n
		};
		function f() {
			var o = new google.feeds.Feed(m);
			if (g.item_count) {
				o.setNumEntries(g.item_count)
			}
			o.load(function(p) {
				if (!p.error) {
					d(p.feed.entries)
				}
			})
		}

		function d(o) {
			var p = "";
			a.each(o, function(s, t) {
				var r = "<span class='parss-title'><a href='" + t.link + "'>" + t.title + "</a></span>";
				if (g.date_format && g.date_format.length > 0) {
					r += "<span class='parss-date'>" + k(t.publishedDate, g.date_format) + "</span>"
				}
				switch(g.show_descriptions) {
					case"image":
						var q = h(t.content);
						if (q) {
							r += "<span class='parss-image'>" + q + "</span>"
						}
						r += "<span class='parss-description'>" + t.contentSnippet + "</span>";
						break;
					case"content":
						r += "<span class='parss-description'>" + t.content + "</span>";
						break;
					case true:
					case"true":
						r += "<span class='parss-description'>" + t.contentSnippet + "</span>";
						break;
					default:
						break
				}
				p += "<li>" + r + "</li>"
			});
			jQuery(i).empty().append(p);
			if ( typeof n == "function") {
				n.call(this)
			}
		}

		function k(p, s) {
			var o = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], t = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], p = new Date(Date.parse(p)), r = "";
			for (var q = 0; q < s.length; q += 1) {
				switch(s.charAt(q)) {
					case"d":
						r += e(p.getDate());
						break;
					case"D":
						r += t[p.getDay()].substring(0, 3);
						break;
					case"j":
						r += p.getDate();
						break;
					case"l":
						r += t[p.getDay()];
						break;
					case"N":
						r += p.getDay() + 1;
						break;
					case"S":
						r += j(p.getDate());
						break;
					case"w":
						r += p.getDay();
						break;
					case"z":
						break;
					case"W":
						break;
					case"F":
						r += o[p.getMonth()];
						break;
					case"m":
						r += e(p.getMonth() + 1);
						break;
					case"M":
						r += o[p.getMonth()].substring(0, 3);
						break;
					case"n":
						r += p.getMonth() + 1;
						break;
					case"t":
						break;
					case"L":
						break;
					case"o":
					case"Y":
						r += p.getFullYear();
						break;
					case"y":
						r += p.getFullYear().toString().substring(-2);
						break;
					case"a":
						r += (p.getHours() < 12) ? "am" : "pm";
						break;
					case"A":
						r += (p.getHours() < 12) ? "AM" : "PM";
						break;
					case"B":
						break;
					case"g":
						r += (p.getHours() > 12) ? p.getHours() - 12 : p.getHours();
						break;
					case"G":
						r += p.getHours();
						break;
					case"h":
						r += e((p.getHours() > 12) ? p.getHours() - 12 : p.getHours());
						break;
					case"H":
						r += e(p.getHours());
						break;
					case"i":
						r += e(p.getMinutes());
						break;
					case"s":
						r += e(p.getDate());
						break;
					case"u":
						r += p.getMilliseconds();
						break;
					case"e":
						break;
					case"O":
					case"P":
						r += p.getTimezoneOffset();
						break;
					case"T":
						break;
					case"Z":
						break;
					case"c":
						r += p.toUTCString();
						break;
					case"r":
						r += p.toDateString();
						break;
					case"U":
						r += p.valueOf();
						break;
					default:
						r += s.charAt(q);
						break
				}
			}
			return r
		}

		function j(p) {
			var o = parseInt(p.toString().substring(p.toString().length - 1));
			switch(o) {
				case 1:
					return "st";
					break;
				case 2:
					return "nd";
					break;
				case 3:
					return "rd";
					break;
				default:
					return "th";
					break
			}
		}

		function e(o) {
			var p = o.toString();
			if (p.length < 2) {
				p = "0" + p
			}
			return p
		}

		function h(p) {
			var o = p.match(/<img[^>+]*>/i);
			if (o) {
				var q = o[0].match(/src="[^"+]*"/i), r = o[0].match(/alt="[^"+]*"/i);
				return "<img " + q + " " + r + " />"
			}
			return false
		}
		a.getScript("https://www.google.com/jsapi", function() {
			google.load("feeds", "1", {
				callback : f
			})
		})
	}
})(jQuery, this);
