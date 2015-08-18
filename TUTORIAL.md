# Using the Meteorstrap Editor

For a tutorial on how to get started with editing, please read this guide. It will cover the basics of creating custom themes in Meteorstrap. For the video-learners, check out this video: [TBC]

### Tweaking Theme Variables

By default, Meteorstrap will come with at least one theme, 'Vanilla Bootstrap' by Twitter, which is plain old Bootstrap with no custom variables and no custom LESS. If you've changed the default theme to something else, change it back to Vanilla Bootstrap for the sake of this guide.

Visit the editor (by including `{{> Meteorstrap}}` somewhere in your project. The first thing you'll see is to textareas for Custom LESS and Theme Less. Ignore those for now.

Scroll down a bit to the variables section, peruse the available options, navigate around, and search for `@grey-base`. Let's override this with `red`. As soon as you make the change, you should notice that all of the text is now red! Wow. Meteorstrap just re-compiled Bootstrap but with a red grey-base.

Whenever you override a variable in the editor, an `override` is created for that particular variable, which is used during the compilation of LESS instead of the `default` variable. Each time you change a varaible the theme is recompiled, so as you tweak the variables in the editor, you'll notice the CSS automatically changes with in a few seconds.

Whenever you delete an override, the theme will fallback to the default variable. To delete an override simple remove the text from that variable input box.

Play around for a bit, and try to make your theme as ugly as possible.

Now let's reset the theme to default Vanilla Bootstrap, by clicking the 'Editing: ...' button at the top and hitting 'Reset Theme'. After confirming, you'll be back to plain old Bootstrap.

### Edit Custom LESS

You can also enter custom LESS (including variables) in the custom LESS box. To try this out, let's write the following:

```less
body {
  background: lighten(@brand-primary, 40%);
}
```
This is LESS, which is similar to CSS (and is backwards compatible), but allows you to have functions and variables as above. Read more about less over at [http://lesscss.org/](http://lesscss.org/). The example above should turn your background a nice baby blue. Feel free to write your own other LESS/CSS.

If you notice an error message appear above this box, there was a problem compiling the theme which probably means there is a syntax error somewhere. It's most likely in custom CSS but could also be in any of the variables boxes.

### Creating a Custom Theme

When you're happy with your changes, why not convert this into a new theme? This way, you can always revert back to Vanilla Bootstrap if you want to.

Simply click the 'Clone Theme' button, which will prompt you to enter a theme name and an author name. It will copy the current theme and use it to generate a new user-defined theme. All that's happening here is that vanilla `overrides` are being saved as `defaults` of the new theme and Custom LESS is being added to vanilla Theme LESS.

You can then go on to make your own overrides and custom less on your theme and can revert back at any time. Remember, the flow for building your own theme goes as follows:

1. Identify a 'base theme' you wish to build from
2. Enter all of the overrides and custom CSS you want
3. Use 'clone theme' once it's ready
4. Reset the old theme unless you want to tweak it further

You can delete custom themes (but no pre-defined themes) at any time.

