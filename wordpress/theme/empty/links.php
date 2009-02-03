<?php
/*
Template Name: Links
*/
?>
<?php get_header(); ?>
<div id="content" class="links-page">
	<h2 title="links">Links</h2>
	<ul>
		<?php wp_list_bookmarks(); ?>
	</ul>
</div>
<?php get_footer(); ?>