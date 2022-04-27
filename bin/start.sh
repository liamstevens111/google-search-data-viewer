#!/bin/sh

bin/google_search_data_viewer eval "GoogleSearchDataViewer.ReleaseTasks.migrate()"

bin/google_search_data_viewer start
