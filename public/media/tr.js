    function handleSearch(event)
        {
                  var queryField = document.getElementById('tr-search-query');
                        query = encodeURIComponent(queryField.value);
                              document.location = "/search/" + query;
                                  }

    function handleTimeline(event)
        {
                  var queryField = document.getElementById('tr-timeline-query');
                        query = encodeURIComponent(queryField.value);
                              document.location = "/user/" + query;
                                  }

    function handleRandom(event)
        {
                  document.location = "/random"
                          }
