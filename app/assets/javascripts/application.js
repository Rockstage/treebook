// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.mobile
//= require js-routes
//= require_tree .

window.loadedActivities = [];

var addActivity = function(item) {
	var found = false;
	for (var i = 0; i < window.loadedActivities.length; i++) {
		if (window.loadedActivities[i].id == item.id) {
			var found = true;
		}
	}

	if (!found) {
		window.loadedActivities.push(item);
		window.loadedActivities.sort(function(a, b) {
			var returnValie
			if (a.created_at > b.created_at)
				returnValue = -1;
			if (a.created_at < b.created_at)
				returnValue = 1;
			if (a.created_at == b.created_at)
				returnValue = 0;
			return returnValue;
		});
	}

	return item;
}


var renderActivities = function() {
	var source = $('#activities-template').html();
	var template = Handlebars.compile(source);
	var html = template({
		activities: window.loadedActivities, 
		count: window.loadedActivities.length
	});
	var $activityFeedLink = $('ul#activity-feed');
	// var $activityFeedList = $(ul#notifications);

	// $activityFeedLink.html(html);
	$activityFeedLink.html(html);
	// $activityFeedLink.addClass('dropdown');
	// $activityFeedLink.html(html);
	// $activityFeedLink.find('a.dropdown-toggle').dropdown();
}


var pollActivity = function() {
	$.ajax({
		url: Routes.activities_path({format: 'json', since: window.lastFetch}),
		type: "GET",
		dataType: "json",
		success: function(data) {
			window.lastFetch = Math.floor((new Date).getTime() / 1000);
			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					addActivity(data[i]);
				}
				renderActivities();
			}
		}
	});
}

Handlebars.registerHelper('activityFeedLink', function() {
	return new Handlebars.SafeString(Routes.activities_path());
});

Handlebars.registerHelper('activityLink', function() {
	var link, path, html;
	var activity = this;
	var linkText = activity.targetable_type.toLowerCase();

  switch (linkText) {
    case "status":
      path = Routes.status_path(activity.targetable_id);
      break;
    case "album":
      path = Routes.album_path(activity.profile_name, activity.targetable_id);
      break;
    case "picture":
      // path = Routes.album_pictures_path(activity.profile_name, activity.album_id);
      path = Routes.album_picture_path(activity.profile_name, activity.targetable.album_id, activity.targetable_id);
      // path = Routes.album_pictures_path(activity.profile_name, activity.targetable_id);
      break;
      // Problem in either the Album_id, which works in activities index or with user_id
    case "userfriendship":
      path = Routes.profile_path(activity.profile_name);
      linkText = "friend";
      break;
  }
	
	// html = "<li class='notificationItem'><a class='notificationLink' href='" + path + "'>" + this.user_name + " " + this.action + " a " + linkText + ".</a></li>";
	html = "<li data-corners='false' data-shadow='false' data-iconshadow='true' data-wrapperels='div' data-icon='arrow-r' data-iconpos='right' data-theme='a' class='ui-btn ui-btn-up-a ui-btn-icon-right ui-li-has-arrow ui-li'><div class='ui-btn-inner ui-li'><div class='ui-btn-text'><a href='" + path + "' data-transition='slide' class='ui-link-inherit notificationLink'>" + this.user_name + " " + this.action + " a " + linkText + ".</a></div><span class='ui-icon ui-icon-arrow-r ui-icon-shadow'>&nbsp;</span></div></li>";
	return new Handlebars.SafeString( html );
});

window.pollInterval = window.setInterval( pollActivity, 30000 );
pollActivity();









