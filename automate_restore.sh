#Starting the Snapshot from Production Elasticsearch with current date
curl -XPUT "https://vpc-production.us-west-1.es.amazonaws.com/_snapshot/my-snapshot-repo/`date +%Y-%m-%d`"


#Start the execution only if the snapshot request was successful from the previous command
if [ $? -eq 0 ];
then
	sleep 600
 	curl -s -XGET "https://vpc-staging.us-west-1.es.amazonaws.com/_snapshot/my-snapshot-repo/_all?pretty" | jq '.snapshots[-1].snapshot, .snapshots[-1].state'> /tmp/state
	ddate=$(cat /tmp/state | head -1)
	dstate=$(cat /tmp/state | tail -1)
        #Delete everything from Stage Cluster
	curl -XDELETE "https://vpc-staging.us-west-1.es.amazonaws.com/_all"
	sleep 120
	#Restore Snapshot on Stage Cluster
	curl -XPOST "https://vpc-staging-.us-west-1.es.amazonaws.com/_snapshot/my-snapshot-repo/`date +%Y-%m-%d`/_restore"
 	echo "Snapshot-Date --> $ddate and Status --> $dstate" | mailx -r abhineetraj@hotmail.com -s "Stage Elasticsearch Restore Complete - `date`"  abhineetraj@hotmail.com 
fi
