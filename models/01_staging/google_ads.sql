with
  google_ads_aggr as (
    select
      date_trunc(date, week(monday)) as week_start,
      replace(lower(advertising_channel_type), ' ', '_') as channel_type,
      sum(impressions) as impressions,
      sum(cost) as cost,
      sum(clicks) as clicks
    from {{ source('google_ads', 'GOOGLEADS_MMM_MODELS') }}
    group by 1,2
  ),

  google_ads as (
      select
          week_start,
          {{ pivot_value_first(
          'channel_type',
          ['demand_gen','multi_channel','display','performance_max','search','video'],
          'cost',
          else_value='0',
          agg='sum',
          prefix='media_'
      ) }},
      {{ pivot_value_first(
          'channel_type',
          ['demand_gen','multi_channel','display','performance_max','search','video'],
          'impressions',
          else_value='0',
          agg='sum',
          prefix='media_'
      ) }},
      {{ pivot_value_first(
          'channel_type',
          ['demand_gen','multi_channel','display','performance_max','search','video'],
          'clicks',
          else_value='0',
          agg='sum',
          prefix='media_'
      ) }}
    from google_ads_aggr
    group by week_start
  )

  select * from google_ads