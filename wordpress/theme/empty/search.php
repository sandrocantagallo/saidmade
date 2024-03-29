<?php get_header(); ?>
	<div id="search-page" class="content">
	<?php if (have_posts()) : ?>
		<h2 class="pagetitle" title="Risultati della ricerca">Risultati della ricerca</h2>

		<?php if( $wp_query->max_num_pages > 1 ) { ?>
		<div class="navigation">
			<div class="alignleft"><?php next_posts_link( '&laquo; precedenti' ) ?></div>
			<div class="alignright"><?php previous_posts_link( 'successivi &raquo;') ?></div>
		</div>
		<?php } ?>

		<?php while (have_posts()) : the_post(); ?>

			<div class="post">
				<h2 id="post-<?php the_ID(); ?>"><a href="<?php the_permalink() ?>" rel="bookmark" title="<?php printf( 'Permalink a %s', the_title_attribute('echo=0')); ?>"><?php the_title(); ?></a></h2>
				<small class="datepost"><?php the_time('j F, Y') ?></small>

				<p class="postmetadata"><?php the_tags( 'Tags: ', ', ', '<br />'); ?> <?php printf( 'Pubblicato in %s', get_the_category_list(', ')); ?> | <?php edit_post_link( 'Modifica', '', ' | '); ?>  <?php comments_popup_link( 'Nessun Commento &#187;', '1 Commento &#187;', '% Commenti &#187;', '', 'Commenti Chiusi' ); ?></p>

			</div>

		<?php endwhile; ?>

		<?php if( $wp_query->max_num_pages > 1 ) { ?>
		<div class="navigation">
			<div class="alignleft"><?php next_posts_link( '&laquo; precedenti' ) ?></div>
			<div class="alignright"><?php previous_posts_link( 'successivi &raquo;') ?></div>
		</div>
		<?php } ?>

	<?php else : ?>

		<h2 class="center">Spiacente ma non &egrave; stato trovato nessun post con i criteri di ricerca impostati:</h2>
		<?php include (TEMPLATEPATH . '/searchform.php'); ?>

	<?php endif; ?>

	</div>

<?php get_sidebar(); get_footer(); ?>