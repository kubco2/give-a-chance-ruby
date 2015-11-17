# RAILS APP + Deployment

Views must fulfill some requirements otherwise its just up to you.

[demo on heroku](http://rails-du-demo.herokuapp.com/)

**Full description on lecture !!**

# !!! Heroku has new pricing, free versions must be down couple of hours a day, so the demo may be unavailable for some period of time !!!

## Init
After creating new rails app  
gem 'rubocop'  

Copy .rubocop.yml to app root

add to Rakefile:
```ruby
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['app/models', 'app/controllers', 'app/helpers']
  task.fail_on_error = false
end
```

## Models
Post 
 * author - string (validated presence)
 * title - string (validated presence)
 * body - text (validated presence)

Post must have at least one Tag

Tag
* name - string (validates presence and uniqueness)
* default to_param is tag name (we are routing using tag name not tag id)

Association **tag**\*----\***post**
(tag has many posts, post has many tags)


## Routes

* root route - posts index page
* posts
	* index
	* new
	* edit
	* filter (with param tag_name)


### Post index page
Displayas all posts sorded by last edited (updated_at field).  
Posts are displayed in table rows. 1 row == 1 post.

Table row has ID="post-row-#\{post.id\}"  
Inside each row there is element marked by **class**:
* post-author - containts the author(obviously)
* post-title
* post-body
* post-tags - all tag names joined by "," (some, tags, example)

Inside each row there are two links:
* "Edit"
* "Delete"

Contains links to each tag:
 * each link has class 'filter-by-tag'
 * they are sorted by number of posts (tags with the highest number of posts are first)


### Post filter page
Example route: "example.com/posts/filter/cool-tag  
Same as index page but show only posts with specific tag.  
All the rules from index page apply.

### Form (edit, new page)
Has 4 fields:
* text field - author - element id="post_author"
* text field - title - element id="post_title"
* text field - tags_string - element id ="post_tags_string"
	* this field displays current tags as string (separated by ",")
	* user input is separated by "," or " "(white space) and stripped ("ahoj, ako sa mas" becomes tags: ['ahoj', 'ako', 'sa', 'mas'])
* text area - body - element_id="post_body"

Return full error messages  
Validate that post has at least one tag, if not, display error message "**must have at least one tag**"

### Post delete
on post deletion all unused tags are removed (tags that has no posts left)

### Notes
focus on SQL selecting - optimize requests  
split code - controller actions have no more than 10 lines of code  
google - dont write something that is already written for you

# Deploy
Part of your task is to deploy your running application to Heroku (free instance).  
Read the [manual](https://devcenter.heroku.com/articles/getting-started-with-rails4)


# Rubocop
Test with rubocop before submitting
````
bundle exec rake rubocop
````

# Submit
Add a post to [demo](http://rails-du-demo.herokuapp.com/posts/new) with
* author: "your UCO"
* title: "HW-RAILS-URL"
* body: "URL to your heroku app"
* tags: "submitted"

Add README.md to your app root containing your app url (on heroku).

Pack with:
````
tar czf ukol.tar.gz *
````

Submit to:
