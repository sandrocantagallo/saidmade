<?php get_header(); ?>
	<div id="content" class="single-page">

	<?php if (have_posts()) : while (have_posts()) : the_post(); ?>

		<div class="navigation">
			<div class="left"><?php previous_post_link('&laquo; %link') ?></div>
			<div class="right"><?php next_post_link('%link &raquo;') ?></div>
		</div>

		<div class="post" id="post-<?php the_ID(); ?>">
			<h2><?php the_title(); ?></h2>

			<div class="entry">
				<?php the_content('<p class="serif">Continua...</p>'); ?>

				<?php wp_link_pages(array('before' => '<p><strong>Pagine: </strong> ', 'after' => '</p>', 'next_or_number' => 'number')); ?>			
			</div>
			<div class="relatedposts rborder4 tdborder">
				<?php st_related_posts("number=5"); ?>
			</div>

			<?php the_tags( '<p class="postmetadata">Tags: ', ', ', '</p>'); ?>
		</div>

		<?php comments_template(); ?>
	
		<?php endwhile; else: ?>
	
		<p>Nessun post</p>

	<?php endif; ?>

	</div>

<?php get_sidebar(); get_footer(); ?>