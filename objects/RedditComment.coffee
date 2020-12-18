import RedditFlair from '/objects/RedditFlair.coffee'
import RedditListingSlice from '/objects/RedditListingSlice.coffee'

export default class RedditComment
	constructor: (raw) ->
		@awards =
			list: []
			spend: raw.all_awardings.fold(0, (a, b) -> a + b.coin_price * b.count)
		@author =
			name: raw.author
			premium: raw.author_premium
		@badges = [
			if raw.distinguished is 'moderator' then 'mod' else raw.distinguished,
			if raw.is_submitter then 'op' else null
		].filter((a) -> a)
		@content =
			text: raw.body_html[16...-6]
		@flags =
			archived: raw.archived
			edited: raw.edited
			locked: raw.locked
			nsfw: raw.over_18
			pinned: raw.stickied
			quarantined: raw.quarantine
			removed: raw.body is '[removed]'
			saved: raw.saved
			scoreHidden: raw.score_hidden
		@flairs =
			author: new RedditFlair(raw.author_flair_text, raw.author_flair_background_color)
		@id = raw.id
		@listingId = raw.subreddit_name_prefixed.toLowerCase()
		@permalink = '/' + @listingId + '/' + @postId + '-' + @id + '-3'
		@postId = raw.link_id[3..]
		@replies = new RedditListingSlice(raw.replies)
		@stats =
			controversiality: raw.controversiality
			score: raw.score - 1
		@times =
			edit: raw.edited or NaN
			parse: Date.now() // 1000
			submit: raw.created_utc