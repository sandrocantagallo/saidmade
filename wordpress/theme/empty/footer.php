	<div id="footer">
		<p>
			<?php printf( '%1$s &egrave; basato su %2$s', get_bloginfo('name'),
			'<a href="http://wordpress.org/">WordPress</a>'); ?>
			<br /><?php printf( '%1$s e %2$s', '<a href="' . get_bloginfo('rss2_url') . '">' . 'Feed (RSS)' . '</a>', '<a href="' . get_bloginfo('comments_rss2_url') . '">' . 'Commenti (RSS)' . '</a>'); ?>
		</p>
		<p><a href="http://www.saidmade.com"><img src="http://labs.saidmade.com/images/sm-a-80x15.png" border="0" alt="saidmade.com" /></a></p>
	</div>
</div>
<?php wp_footer(); ?>
</body>
</html>