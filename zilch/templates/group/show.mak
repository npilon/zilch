<%def name="post_body()">
<section class="filters">
    <h3>Filters</h3>
    <div>
        <p>Apply Filter 1</p>
    </div>
</section>
</%def>

<h1>${group.message}</h1>
<p>Showing most recent event with details.</p>

${display_httpexception(last_event)}

<%def name="javascript()">
${parent.javascript()}
<script>
$(document).ready(function() {
    $('div.traceback-frames div.frame').toggle(function() {
        $(this).find('pre.around, div.localvars').toggle();
        $(this).find('pre.context_line').toggleClass('highlight');
    }, function() {
        $(this).find('pre.around, div.localvars').toggle();
        $(this).find('pre.context_line').toggleClass('highlight');        
    });
});
</script>
</%def>

<%def name="display_httpexception(event)">
<section class="httpexception">
    <% extra = event.data.get('extra', {}) %>
    <p class="recorded">Event occured <time datetime=${event.datetime}>${display_date(event.datetime)}</time></p>
    <div class="full_traceback">
        <h2>Complete Traceback with Details</h2>
        ${full_traceback(event.data['frames'])}
    </div>
    % if 'CGI Variables' in extra:
    <div class="cgi">
        ${display_table('CGI Variables', ('Variable', 'Value'), extra['CGI Variables'], header_type=2)}
    </div>
    % endif
    % if 'WSGI Variables' in extra:
    <div class="wsgi">
        ${display_table('WSGI Variables', ('Variable', 'Value'), extra['WSGI Variables'], header_type=2)}
    </div>
    % endif
    <div class="plain_traceback">
        <h2>Plaintext Traceback</h2>
        <pre>
        ${event.data['traceback']}
        </pre>
    </div>
</section>
</%def>
<%def name="full_traceback(frames)">
<div class="traceback-frames">
% for frame in frames[::-1]:
    <div class="frame">
        <h4>Module <cite class="module">${frame['module']}</cite>:
            <em class="line">${frame['lineno']}</em>,
            in <code class="function">${frame['function']}</code></h4>
        <div class="context">
            <pre class="around">${'\n'.join(frame.get('pre_context', [])[-3:])}</pre>
            <pre class="context_line">${frame.get('context_line')}</pre>
            <pre class="around">${'\n'.join(frame.get('post_context', [])[:-3])}</pre>
        </div>
        <div class="localvars">
            ${display_table('Local Variables', ('Variable', 'Value'), frame['vars'], 4)}
        </div>
    </div>
% endfor
</div>
</%def>
<%def name="display_table(header_name, table_header, table_dict, header_type='3')">
<h${header_type}>${header_name}</h${header_type}>
<table>
    <thead>
        % for header in table_header:
        <th>${header}</th>
        % endfor
    </thead>
    <tbody>
    % for key in sorted(table_dict.keys()):
        <tr>
            <td class="key">${key}</td><td>${table_dict[key]}</td>
        </tr>
    % endfor
    </tbody>
</table>

</%def>
<%def name="title()">${parent.title()} - Group ${group.id}</%def>
<%def name="breadcrumbs()">${parent.breadcrumbs()} &gt; ${group.id}</%def>
<%inherit file="layout.mak"/>
<%namespace file="/common.mak" import="display_date"/>