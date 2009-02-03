<div id="sidebar">
	<?php include (TEMPLATEPATH . '/searchform.php'); ?>
	<ul>
		<?php wp_list_pages('title_li=<h2 title="Pagine">Pagine</h2>' ); ?>
		
		<li>
			<h2 title="Archivi">Archivi</h2>
			<ul>
			<?php wp_get_archives('type=monthly'); ?>
			</ul>
		</li>
		
		<?php wp_list_categories('show_count=1&title_li=<h2 title="Categorie">Categorie</h2>'); ?>

		<li>
			<h2 title="Links">Links</h2>
			<ul>
				<li><a href="http://www.saidmade.com">Saidmade</a></li>
				<li><a target="_blank" href="http://www.flussodigitale.com">Flussodigitale.com</a></li>
				<li><a target="_blank" href="http://www.undolog.com">Undolog.com</a></li>
			</ul>
		</li>
	
	</ul>
</div>