public with sharing class QueryService {
    public static final String COMMA_SEPARATED_FIELD_NAMES_REGEX = '^([A-Za-z0-9_]+)(?:,([A-Za-z0-9_]+))*$';

    public static PaginatedResults getRecords(
        List<String> fieldApiNames,
        SObjectType sObjectType,
        List<String> filters
    ) {
        System.debug('fieldApiNames: ' + fieldApiNames);
        System.debug('sObjectType: ' + sObjectType);
        System.debug('filters: ' + filters);

        PaginatedResults paginatedResults = new PaginatedResults();

        try {
            System.debug('Building SOQL query');

            QueryFactory queryFactory = new QueryFactory()
                .setSObjectType(String.valueOf(sObjectType))
                .setFields(fieldApiNames)
                .setFilters(filters);

            String recordQuery = queryFactory.toRecordQuery();
            String countQuery = queryFactory.toCountQuery();

            System.debug('recordQuery: ' + recordQuery);
            System.debug('countQuery: ' + countQuery);

            paginatedResults.results = Database.query(recordQuery);
            paginatedResults.totalResults = Database.countQuery(countQuery);
        } catch (Exception e) {
            paginatedResults.error = e.getMessage();
        }

        return paginatedResults;
    }

    public static List<String> getFieldApiNamesFromCommaSeparatedList(String commaSeparatedFields) {
        System.debug('commaSeparatedFields: ' + commaSeparatedFields);

        Pattern pattern = Pattern.compile(COMMA_SEPARATED_FIELD_NAMES_REGEX);
        Matcher matcher = pattern.matcher(commaSeparatedFields);
        Boolean matchesRegex = matcher.matches();

        System.debug('matchesRegex: ' + matchesRegex);

        if (matchesRegex) {
            List<String> fieldApiNames = new List<String>();

            for (Integer i = 1; i < matcher.groupCount(); i++) {
                System.debug('group: ' + matcher.group(i));
                fieldApiNames.add(matcher.group(i));
            }

            return fieldApiNames;
        } else {
            throw new QueryException('Not a valid list of comma-separated field names');
        }
    }
}
