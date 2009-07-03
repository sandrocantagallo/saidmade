<?php get_header(); ?>
	<div id="index-page" class="content">
	<?php if (have_posts()) : ?>
		<?php while (have_posts()) : the_post(); ?>
			<div class="post" id="post-<?php the_ID(); ?>">
				<h2 id="post-<?php the_ID(); ?>"><a href="<?php the_permalink() ?>" rel="bookmark" title="<?php printf( 'Permalink a %s', the_title_attribute('echo=0')); ?>"><?php the_title(); ?></a></h2>
				<small class="datepost"><?php the_time('j F, Y') ?></small>

				<div class="entry">
					<?php the_content( 'continua &raquo;' ); ?>
				</div>

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

		<h2 class="center">Non trovato</h2>
		<p class="center">Spiacenti, ma la pagina che cercavi non � stata trovata. Prova a cercare meglio nel sito</p>
		<?php include (TEMPLATEPATH . "/searchform.php"); ?>

	<?php endif; ?>

	</div>

<?php get_sidebar(); get_footer(); ?>