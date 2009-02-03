<?php // Do not delete these lines
	if (isset($_SERVER['SCRIPT_FILENAME']) && 'comments.php' == basename($_SERVER['SCRIPT_FILENAME']))
		die ('Please do not load this page directly. Thanks!');

	if (!empty($post->post_password)) { // if there's a password
		if ($_COOKIE['wp-postpass_' . COOKIEHASH] != $post->post_password) {  // and it doesn't match the cookie
			?>

			<p class="nocomments"><?php _e('This post is password protected. Enter the password to view comments.', 'kubrick'); ?></p>

			<?php
			return;
		}
	}

	/* This variable is for alternating comment background */
	$oddcomment = 'alt';
?>

<!-- You can start editing here. -->

<?php if ($comments) : ?>
	<h3 id="comments"><?php comments_number( 'Nessun commento', 'Un Commento', '% Commenti');?> <?php printf( 'a &#8220;%s&#8221;', the_title('', '', false)); ?></h3>

	<ol class="commentlist">

	<?php foreach ($comments as $comment) : ?>

		<li class="<?=$oddcomment?> rborder8 tdborder" id="comment-<?php comment_ID() ?>">
			<?php echo get_avatar( $comment, 32 ); ?>	
			<?php printf( '<cite>%s</cite> ha detto:', get_comment_author_link()); ?>
			<?php if ($comment->comment_approved == '0') : ?>
			<em>Il tuo commento è in attesa di moderazione...</em>
			<?php endif; ?>
			<br />

			<small class="commentmetadata"><a href="#comment-<?php comment_ID() ?>" title=""><?php printf( '%1$s alle %2$s', get_comment_date( 'j F, Y'), get_comment_time()); ?></a> <?php edit_comment_link( 'modifica','&nbsp;&nbsp;',''); ?></small>

			<?php comment_text() ?>

		</li>

	<?php
		/* Changes every other comment to a different class */
		$oddcomment = ( empty( $oddcomment ) ) ? 'alt' : '';
	?>

	<?php endforeach; /* end for each comment */ ?>

	</ol>

 <?php else : // this is displayed if there are no comments so far ?>

	<?php if ('open' == $post->comment_status) : ?>
		<!-- If comments are open, but there are no comments. -->

	 <?php else : // comments are closed ?>
		<!-- If comments are closed. -->
		<p class="nocomments">Commento chiusi...</p>

	<?php endif; ?>
<?php endif; ?>


<?php if ('open' == $post->comment_status) : ?>

<h3 id="respond">Lascia un commento:</h3>

<?php if ( get_option('comment_registration') && !$user_ID ) : ?>
<p><?php printf( 'Devi esere <a href="%s">loggato</a> per scrivere un commento.', get_option('siteurl') . '/wp-login.php?redirect_to=' . urlencode(get_permalink())); ?></p>
<?php else : ?>

<form class="rborder4 tdborder" action="<?php echo get_option('siteurl'); ?>/wp-comments-post.php" method="post" id="commentform">

<?php if ( $user_ID ) : ?>

<p><?php printf( 'Loggato come <a href="%1$s">%2$s</a>.', get_option('siteurl') . '/wp-admin/profile.php', $user_identity); ?> <a href="<?php echo get_option('siteurl'); ?>/wp-login.php?action=logout" title="Scollegati">Scollegati</a></p>

<?php else : ?>

<p><input type="text" name="author" id="author" value="<?php echo $comment_author; ?>" size="22" tabindex="1" <?php if ($req) echo "aria-required='true'"; ?> />
<label for="author"><small>Nome <?php if ($req) echo "(richiesto)"; ?></small></label></p>

<p><input type="text" name="email" id="email" value="<?php echo $comment_author_email; ?>" size="22" tabindex="2" <?php if ($req) echo "aria-required='true'"; ?> />
<label for="email"><small>email <?php if ($req) echo "(richiesto)"; ?></small></label></p>

<p><input type="text" name="url" id="url" value="<?php echo $comment_author_url; ?>" size="22" tabindex="3" />
<label for="url"><small>Website</small></label></p>

<?php endif; ?>

<!--<p><small><?php printf( '<strong>XHTML:</strong> Puoi usare questi tag: <code>%s</code>', allowed_tags()); ?></small></p>-->

<p><textarea name="comment" id="comment" cols="50%" rows="10" tabindex="4"></textarea></p>

<p class="aligncenter"><input class="rborder4" name="submit" type="submit" id="submit" tabindex="5" value="Invia" />
<input type="hidden" name="comment_post_ID" value="<?php echo $id; ?>" />
</p>
<?php do_action('comment_form', $post->ID); ?>

</form>

<?php endif; // If registration required and not logged in ?>

<?php endif; // if you delete this the sky will fall on your head ?>
