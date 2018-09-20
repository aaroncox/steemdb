<!DOCTYPE html>
<html>
  {% include '_elements/layouts/head.volt' %}
  <body>

    {% include '_elements/layouts/menu.volt' %}

    <!-- Page Contents -->
    <div class="pusher" style="padding-top: 3em">

      {% include "_elements/warning.volt" %}

      {% block content %}{% endblock %}

      {% include '_elements/layouts/footer.volt' %}

    </div>

    {% include '_elements/layouts/scripts.volt' %}
    {% block scripts %}{% endblock %}
  </body>
</html>
