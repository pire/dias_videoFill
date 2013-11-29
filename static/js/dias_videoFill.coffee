( ($, $win) ->
    'use strict'

    ################################
    # Video Resize
    #
    DIAS_videoFill =
        # limit the height and width so we don't go crazy
        maxHeight : 1440
        maxWidth : 2560
        minHeight: 240
        minWidth : 280
        # padding around the video
        padding: 0
        init : ->
            items = this.cacheItems()

            if not items
                return false

            this.bindEvents()
        cacheItems : ->
            # cache the video items
            this.$videos  = $('.dias-video-filler video, .dias-video-filler iframe')

            if( this.$videos.length < 1 )
                return false

            # cache the container of the video
            this.$videos.each( ->
                $this = $(this)
                $this.data('parent', $this.parent())
            )

            # make sure videos are centered
            this.$videos.css(
                left: '50%'
                top: '50%'
            )

        bindEvents : ->
            # bind event listeners
            _this = this

            this.$videos.bind('load loadedmetadata', ->
                _this.cacheAspect($(this))
            )

            $win.bind('resize', ->
                _this.videosResize()
            )
        cacheAspect : ($video) ->
            # cache aspect ratio for video
            $this = $video
            width = $this.width()
            height = $this.height()

            $this.data('ratio', width/height)

            # make sure video is resized correctly
            this.videoResize($this)
        videoResize : ($video) ->
            # resize video to fill parent container
            aspectRatio = $video.data('ratio')
            $parent = $video.data('parent')
            pHeight = $parent.height()
            pWidth = $parent.width()

            if not aspectRatio?
                aspectRatio = $this.width() / $video.height()

            parentRatio = pWidth/pHeight

            if( parentRatio < aspectRatio )
                vidHeight = Math.min(Math.max(pHeight, this.minHeight), this.maxHeight) - this.padding
                vidWidth = vidHeight * aspectRatio
            else
                vidHeight = Math.min(Math.max(pWidth / aspectRatio, this.minHeight), this.maxHeight) - this.padding
                vidWidth = vidHeight * aspectRatio;

            $video.css(
                height : vidHeight
                width : vidWidth
                marginTop : (-vidHeight/2)
                marginLeft : (-vidWidth/2)
            )

            return $video
        videosResize : ->
            _this = this
            # on window resize cycle through each video
            # and resize it to fill the parent
            _this.$videos.each( ->
              _this.videoResize($(this))
            )

    DIAS_videoFill.init();
    #
    # Video Resize
    ################################

)(jQuery, jQuery(window))